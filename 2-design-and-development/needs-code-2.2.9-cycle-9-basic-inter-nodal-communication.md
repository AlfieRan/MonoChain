# \[needs code] 2.2.10 Cycle 10 - Basic Inter-Nodal Communication

* STOP NODES FROM JUST SIGNING ALL DATA SENT THEIR WAY -> MASSIVE SECURITY FLAW
* Convert pong route from a get request to a post request
* move pong request data from query to body
* create an info getter that just asks a node for all it's info in more detail.

## Design

### Objectives

The objective for this cycle is to turn the [basic inter-nodal communication from Cycle 6](2.2.6-cycle-6-setting-up-inter-nodal-communication.md) into something a little more advanced, allowing Nodes to start using post requests rather than get requests so that the data can be supplied within the body of the request, and other similar quality of life upgrades.

Alongside this there is also a very bad security flaw with the way in which Nodes sign data sent to their pong routes, and that is that they will just sign anything sent their way. This means that node A could just ask node B to sign a transaction that gives all of B's assets to A and then B would just do it and send the signed transaction back to A. This is obviously bad and needs to be fixed.

* [ ] Make nodes check the data sent to their pong route and only sign it if it is a dateTime string.
* [ ] Convert pong request from a get request to a post request.
* [ ] Move pong request data from the query of the request to the body.
* [ ] Create an info getter route that asks a node for all of its information - will be useful in the future.

### Usability Features

* Feature 1
* Feature 2

### Key Variables

| Variable Name | Use |
| ------------- | --- |
|               |     |
|               |     |
|               |     |

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

Objective 2 solution:

```
```

## Development

\---

### Outcome

#### Signing Date-Time Objects

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

This code can be found in [this commit here](https://github.com/AlfieRan/MonoChain/blob/master/packages/node/src/modules/server/main.v), although bear in mind that the code above removed some in-code comments meant for future use in a different cycle that is not in development and is just being planned at the moment.

Objective 2

```
code
```

### Challenges

Challenges faced in either/both objectives

## Testing

### Tests

| Test | Instructions                                                                 | What I expect                                                                        | What actually happens | Pass/Fail |
| ---- | ---------------------------------------------------------------------------- | ------------------------------------------------------------------------------------ | --------------------- | --------- |
| 1    | Completing a correct and valid handshake using a time object as the message. | A series of console logs on both nodes confirming that the handshake was successful. | As expected           | Pass      |
| 2    |                                                                              |                                                                                      |                       |           |
| 3    |                                                                              |                                                                                      |                       |           |

### Evidence

#### Test 1 Evidence - Valid data in a valid handshake

<figure><img src="../.gitbook/assets/image (1).png" alt=""><figcaption><p>The handshake initiator</p></figcaption></figure>

<figure><img src="../.gitbook/assets/image.png" alt=""><figcaption><p>The handshake Recipient</p></figcaption></figure>

As shown, both the initiator and recipient successfully agreed on the handshake, with both showing the same time message to prove this was the same handshake as the test.
