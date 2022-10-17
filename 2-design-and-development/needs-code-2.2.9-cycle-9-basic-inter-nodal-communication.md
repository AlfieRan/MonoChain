# 2.2.10 Cycle 10 - Basic Inter-Nodal Communication

## Design

### Objectives

The objective for this cycle is to turn the [basic inter-nodal communication from Cycle 6](2.2.6-cycle-6-setting-up-inter-nodal-communication.md) into something a little more advanced, allowing Nodes to start using post requests rather than get requests so that the data can be supplied within the body of the request, and other similar quality of life upgrades.

Alongside this there is also a very bad security flaw with the way in which Nodes sign data sent to their pong routes, and that is that they will just sign anything sent their way. This means that node A could just ask node B to sign a transaction that gives all of B's assets to A and then B would just do it and send the signed transaction back to A. This is obviously bad and needs to be fixed.

* [x] Make nodes check the data sent to their pong route and only sign it if it is a dateTime string.
* [x] Convert pong request from a get request to a post request.
* [x] Move pong request data from the query of the request to the body.
* [x] Convert ping/pong terminology into a "handshake" with sufficient renaming

### Usability Features

The main usability feature introduced within this cycle is the renaming and structuring of the "ping/pong" functions and routes within the node software to a "handshake" route which more accurately describes what is actually going on.

### Key Variables

| Variable Name                  | Use                                                                                                                           |
| ------------------------------ | ----------------------------------------------------------------------------------------------------------------------------- |
| <pre><code>config</code></pre> | Stores all the configuration object's data, such as the node's reference to itself, its port and other essential information. |
| <pre><code>keys</code></pre>   | Contains the keys object, which has the ability to sign, validate and verify data.                                            |

### Pseudocode

#### Only signing date-time objects

Luckily implementing this, and dramatically improving the node software's current security, should actually be pretty easy. All the code will need to do is attempt to parse the message received within the handshake (ping/pong) request as a date-time object and if it succeeds, then the message is okay to be signed and if not then fail the request and do not sign it.

Parsing date-time objects is different for every language and standard library so for this pseudocode the function `Parse_Date` will represent a function which takes a string in the format `YYYY-MM-DD hh:mm:ss` and either returns a date-time object in some format or errors out.

```
// Pseudocode

FUNCTION Valid_Message(message):
    TRY:
        date = Parse_Date(message)
        return date
        
    CATCH ERROR:
        return false
        
    END TRY  
END FUNCTION
```

### Converting the handshake route from a get request to a post request

As both the conversion from a get request to a post request and converting from using queries to using the body to send data is so similar I'll use the below examples to summarise both changes.

#### **Api Route**

Because this is based upon code from a previous cycle where I introduced the nodal communication, I've copied that pseudocode as the base and then edited it from there. [Visit here to see the original Pseudocode](2.2.6-cycle-6-setting-up-inter-nodal-communication.md#the-api-route)

```
// Pseudocode

// import functions from modules made in previous cycles
IMPORT configuration
IMPORT cryptography


// In this case request has changed to be the body of the http request
HTTP_POST_ROUTE handshake (request):

	TRY:
		req_parsed = json.decode(request)
	CATCH ERROR:
		OUTPUT "Incorrect data supplied to handshake"
		RETURN HTTP.code(403) 	
		// a code 403 means "forbidden" in http terms
	END TRY



	OUTPUT "Received handshake request from node claiming to have the public key"
		 + req_parsed.initiator_key

	// using the function defined earlier in this cycle
	time = Valid_Message(req_parsed.message)
	
	IF time == False:
		OUTPUT "Incorrect time format supplied to handshake by node claiming to be"
			+ req_parsed.initiator_key
			
		// this is where a negative grudge would then be stored but that's for a
		// future cycle.
		
		RETURN HTTP.code(403) 
	ENDIF
	
	// time was okay, so store a slight positive grudge
	OUTPUT "Time parsed correctly as:" + time
	
	// how the keys are used has also changed due to the node refactor.
	config = configuration.get_config()
	keys = cryptography.get_keys(config.key_path)

	// create an object that represents the response
	response = {
		responder_key: self.pub_key
		initiator_key: req_parsed.initiator_key
		message: req_parsed.message
		signature: keys.sign(message)
	}
	
	// encode the response to be http safe
	data = json.encode(response)
	
	// return it to the requester
	OUTPUT "Handshake Analysis Complete. Sending response..."
	return HTTP.text(data)
END HTTP_ROUTE

```

#### Requester Function

```
// Psuedocode

IMPORT time
IMPORT json
IMPORT http

IMPORT cryptography

FUNCTION start_handshake(ref, this):
	// ref should be an ip or a domain
	
	message = time.now() // set the message to the current time since epoch
	// message = "invalid data" // Invalid data used for testing
	
	request = {initiator_key: this.self.key, message: msg}

	OUTPUT "Sending handshake request to" + ref + ".\nMessage:" + message
	// fetch domain, domain should respond with their wallet pub key/address, "pong" and a signed hash of the message
	request_encoded := json.encode(request)
	
	TRY:
		raw_response = http.post("$ref/handshake", req_encoded)
	CATCH:
		OUTPUT "Failed to shake hands with" + ref + ", Node is probably offline."
		RETURN FALSE
	END TRY

	if raw_response.status_code != 200 {
		OUTPUT "Failed to shake hands with" + ref + ", may have sent incorrect data, repsonse body:" + raw_response.body
		RETURN FALSE
	}

	TRY:
		response = json.decode(HandshakeResponse, raw.body)
	CATCH:
		OUTPUT "Failed to decode handshake response, responder is probably using an old node version.\nTheir Response:" + raw_response
		RETURN FALSE
	END TRY

	OUTPUT "\n" + ref + "responded to handshake."

	// signed hash can then be verified using the wallet pub key supplied
	IF (response.message == message && response.initiator_key == this.self.key):
	
		IF (cryptography.verify(response.responder_key, response.message.bytes(), response.signature):
			OUTPUT "Verified signature to match handshake key\nHandshake with $ref successful."
			RETURN TRUE
		END IF
		
		OUTPUT "Signature did not match handshake key, node is not who they claim to be."
		// this is where we would then store a record of the node's reference/ip address and temporarily blacklist it
		RETURN FALSE
	END IF

	OUTPUT "Handshake was not valid, node is not who they claim to be."
	OUTPUT response
	// if valid, return true, if not return false
	RETURN FALSE
END FUNCTION
```

## Development

The development for this cycle was primarily based upon changing the code, pushing the changes, downloading the new code and running it on two nodes and seeing if either of them had communication issues. This was fairly repetitive but due to having ssh access to both servers It wasn't too time consuming and allowed me to just keep testing the new code until it stopped having errors, which lowered the error rates a lot due to so many tests as I was programming.

### Outcome

### Signing Date-Time Objects

Converting the pseudocode to actual code for this was pretty simple, although I ended up keeping the parsing within the main handshake route function rather than splitting it out into a separate function, so that's why the code isn't in a function below.

```v
// V code - within the "pong" route in /src/modules/server/main.v 

// with this version of the node software all messages should be time objects
time := time.parse(req_parsed.message) or {
    eprintln("Incorrect time format supplied to /pong/:req by node claiming to be $req_parsed.ping_key")
    return app.server_error(403)
}

// time was okay, so store a slight positive grudge
println("Time parsed correctly as: $time")
```

This code can be found in [this commit here](https://github.com/AlfieRan/MonoChain/blob/49d9f53c2253b742795afc40651ba4da988819cb/packages/node/src/modules/server/handshake.v), although bear in mind that the code above removed some in-code comments meant for future use in a different cycle that is not in development and is just being planned at the moment.

### Converting the handshake route from a get request to a post request

#### The Api route

This is the endpoint at which a node will send a http POST request to in order to request a handshake response in accordance to the details sent in the request.

```v
// V code - within the "handshake" route in /src/modules/server/handshake.v 

['/handshake'; post]
pub fn (mut app App) handshake_route() vweb.Result {
	body := app.req.data

	req_parsed := json.decode(HandshakeRequest, body) or {
		eprintln("Incorrect data supplied to /handshake/")
		return app.server_error(403)
	}

	println("Received handshake request from node claiming to have the public key: $req_parsed.initiator_key")


	// THIS IS THE SECTION WRITTEN UNDER THE TITLE "Signing Date-Time Objects"
	// with this version of the node software all messages should be time objects
	time := time.parse(req_parsed.message) or {
		eprintln("Incorrect time format supplied to handshake by node claiming to be $req_parsed.initiator_key")
		return app.server_error(403)
	}

	// time was okay, so store a slight positive grudge
	println("Time parsed correctly as: $time")
	// THIS IS THE SECTION WRITTEN UNDER THE TITLE "Signing Date-Time Objects"


	config := configuration.get_config()
	keys := cryptography.get_keys(config.key_path)

	res := HandshakeResponse{
		responder_key: keys.pub_key
		initiator_key: req_parsed.initiator_key
		message: req_parsed.message
		signature: keys.sign(req_parsed.message.bytes())
	}

	data := json.encode(res)
	println("Handshake Analysis Complete. Sending response...")
	return app.text(data)
}
```

#### The Handshake Requester

This code handles the assembly of a handshake request, then the http request and finally the handling of the returned data then returns a boolean value that represents whether the handshake was successful or not.

```v
// V code - /src/modules/server/handshake.v

pub fn start_handshake(ref string, this configuration.UserConfig) bool {
	// ref should be an ip or a domain
	msg := time.now().format_ss_micro() // set the message to the current time since epoch
	// msg := "invalid data" // Invalid data used for testing
	req := HandshakeRequest{initiator_key: this.self.key, message: msg}

	println("\nSending handshake request to ${ref}.\nMessage: $msg")
	// fetch domain, domain should respond with their wallet pub key/address, "pong" and a signed hash of the message
	req_encoded := json.encode(req)
	
	raw := http.post("$ref/handshake", req_encoded) or {
		eprintln("Failed to shake hands with $ref, Node is probably offline. Error: $err")
		return false
	}

	if raw.status_code != 200 {
		eprintln("Failed to shake hands with $ref, may have sent incorrect data, repsonse body: $raw.body")
		return false
	}

	data := json.decode(HandshakeResponse, raw.body) or {
		eprintln("Failed to decode handshake response, responder is probably using an old node version.\nTheir Response: $raw")
		return false
	}

	println("\n$ref responded to handshake.")

	// signed hash can then be verified using the wallet pub key supplied
	if data.message == msg && data.initiator_key == this.self.key {
		if cryptography.verify(data.responder_key, data.message.bytes(), data.signature) {
			println("Verified signature to match handshake key\nHandshake with $ref successful.")
			return true
		}
		println("Signature did not match handshake key, node is not who they claim to be.")
		// this is where we would then store a record of the node's reference/ip address and temporarily blacklist it
		return false
	}

	println("Handshake was not valid, node is not who they claim to be.")
	println(data)
	// if valid, return true, if not return false
	return false
}
```

[This version of the code can be found here.](https://github.com/AlfieRan/MonoChain/blob/49d9f53c2253b742795afc40651ba4da988819cb/packages/node/src/modules/server/handshake.v)

### Challenges

The main challenge faced in this cycle was surrounding responding to the handshake requests, as in a future cycle I plan to complete a check after a node receives a request to check if they have seen the requester before and if not send them their own request to get info on them.

This involved planning for the future and examining how to get the reference of the node that sent a request, however my initial plan, which was just to examine the http headers failed because due to how my primary node (https://nano.monochain.network) uses cloud-flare tunnelling to increase security so all nodes that send requests appear to have the same ip -> one of cloud-flare's servers. Therefore if I was having that problem then other people probably would as well so after some testing and probing I decided not to try and cover that in this cycle and it will instead be covered in a future cycle.

## Testing

### Tests

| Test | Instructions                                                                    | What I expect                                                                        | What actually happens | Pass/Fail |
| ---- | ------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------ | --------------------- | --------- |
| 1    | Completing a correct and valid handshake using a time object as the message.    | A series of console logs on both nodes confirming that the handshake was successful. | As expected           | Pass      |
| 2    | Completing an invalid handshake using the string "invalid data" as the message. | For both nodes to record the handshake as unsuccessful and log such to the console.  | As expected           | Pass      |

### Evidence

#### Test 1 Evidence - Valid data in a valid handshake

<figure><img src="../.gitbook/assets/image (1) (2) (3).png" alt=""><figcaption><p>The handshake initiator</p></figcaption></figure>

<figure><img src="../.gitbook/assets/image (6) (2) (2).png" alt=""><figcaption><p>The handshake Recipient</p></figcaption></figure>

As shown, both the initiator and recipient successfully agreed on the handshake, with both showing the same time message to prove this was the same handshake as the test.

#### Test 2 Evidence - Invalid data in the handshake

<figure><img src="../.gitbook/assets/image (11) (1).png" alt=""><figcaption><p>The handshake initiator</p></figcaption></figure>

<figure><img src="../.gitbook/assets/image (1) (2).png" alt=""><figcaption><p>The handshake Recipient</p></figcaption></figure>

As shown both nodes classified the handshake as failed, with the initiator predicting that incorrect data may have been sent (although that is not guaranteed as another error may have occurred but in this case we know it was the case of invalid data); and the Recipient logging an incorrect time format supplied and who it was claimed to be supplied by.
