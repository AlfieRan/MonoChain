module server

// internal imports
import configuration
import cryptography
import database

// external imports
import vweb
import json
import time
import net.http

// This is to establish a handshake between two nodes and should be done everytime two nodes connect
pub struct Initiator {
	key []u8
	ref string
}

pub struct HandshakeResponse {
	initiator Initiator
	responder_key []u8
	message string
	signature []u8
}

pub struct HandshakeRequest {
	initiator Initiator
	message string
}

pub struct HandshakeError {
	error string
	code int
}

type HandshakeResult = HandshakeResponse | HandshakeError

enum HandshakeRequestResultEnum {
	blacklist
	accept
	ignore
}

struct HandshakeRequestResult {
	result HandshakeRequestResultEnum
	keys []u8
}

['/handshake'; post]
pub fn (mut app App) handshake_route() vweb.Result {
	db := app.db
	body := app.req.data
	data := handshake_receiver(body, db)

	if data is HandshakeError {
		return app.server_error(data.code)
	}

	return app.json(data)
}

pub fn start_handshake(ref string, this configuration.UserConfig, db database.DatabaseConnection) HandshakeRequestResult {
	println("[Handshake Requester] Start Handshake initiated")
	if ref == this.self.ref {
		println("[Handshake Requester] Sending a request to self, waiting to prevent feedback loops")
		time.sleep(1 * time.second) // wait to make sure not to loop self 


		if db.aware_of(ref) {
			println("[Handshake Requester] Handshake no longer needed, aborting")
			// if another handshake request has occoured during the waiting period and overrights this one
			return HandshakeRequestResult{result: .ignore}
		}
	}

	// ref should be an ip or a domain
	msg := time.now().format_ss_micro() // set the message to the current time since epoch
	// msg := "invalid data" // Invalid data used for testing
	req := HandshakeRequest{initiator: Initiator{key: this.self.key, ref: this.self.ref}, message: msg}


	println("\n[Handshake Requester] Sending handshake request to ${ref}.\n[Handshake Requester] Message: $msg")
	// fetch domain, domain should respond with their wallet pub key/address, "pong" and a signed hash of the message
	req_encoded := json.encode(req)
	
	raw := http.post("$ref/handshake", req_encoded) or {
		eprintln("[Handshake Requester] Failed to shake hands with $ref, Node is probably offline. Error: $err")
		return HandshakeRequestResult{result: .ignore}
	}

	if raw.status_code != 200 {
		eprintln("[Handshake Requester] Failed to shake hands with $ref, may have sent incorrect data, repsonse body: $raw.body")
		return HandshakeRequestResult{result: .ignore}
	}

	data := json.decode(HandshakeResponse, raw.body) or {
		eprintln("[Handshake Requester] Failed to decode handshake response, responder is probably using an old node version.\nTheir Response: $raw")
		return HandshakeRequestResult{result: .ignore}
	}

	println("\n[Handshake Requester] $ref responded to handshake.")
	

	// signed hash can then be verified using the wallet pub key supplied
	if data.message == msg && data.initiator.key == this.self.key {
		if cryptography.verify(data.responder_key, data.message.bytes(), data.signature) {
			println("[Handshake Requester] Verified signature to match handshake key\n[Handshake Requester] Handshake with $ref successful.")
			// now add them to reference list
			return HandshakeRequestResult{
				result: .accept
				keys: data.responder_key
			}
		}
		println("[Handshake Requester] Signature did not match handshake key, node is not who they claim to be.")
		// this is where we would then store a record of the node's reference/ip address and temporarily blacklist it
		return HandshakeRequestResult{result: .blacklist}
	}

	println("[Handshake Requester] Handshake was not valid, node is not who they claim to be.")
	println("[Handshake Requester] $data")
	// node is not who they claim to be, so store their reference/ip address and temporarily blacklist it
	return HandshakeRequestResult{result: .blacklist}
}

pub fn start_handshake_ws(ref string, this configuration.UserConfig, db database.DatabaseConnection) {
	println("[Handshake Requester] Starting Handshake over WS")
	handshake := start_handshake(ref, this, db)
	
	// mut refs := database.get_refs(this.ref_path)

	if handshake.result == .accept {
		println("[Handshake Requester] Adding ref to refs")
		// refs.add_key_ws(ref, handshake.keys)
	}  else if handshake.result == .blacklist {
		println("[Handshake Requester] Blacklisting Handshake with result $handshake")
		// refs.add_blacklist_ws(ref)
	} else {
		println("[Handshake Requester] Not doing anything with result from handshake with $ref")
	}

	println("[Handshake Requester] Handshake Request Finished")
}

pub fn start_handshake_http(ref string, this configuration.UserConfig, db database.DatabaseConnection) {
	println("[Handshake Requester] Starting Handshake over HTTP")
	handshake := start_handshake(ref, this, db)
	println("[Handshake Requester] Completed handshake")

	if handshake.result == .accept {
		println("[Handshake Requester] Adding ref to refs")
		db.create_ref(ref, handshake.keys, false)
	} else {
		println("[Handshake Requester] Not doing anything with result from handshake with $ref (Returned enum $handshake.result)")
	}

	println("[Handshake Requester] Handshake Request Finished")
}

pub fn handshake_receiver(request string, db database.DatabaseConnection) HandshakeResult {
	req_parsed := json.decode(HandshakeRequest, request) or {
		eprintln("[Handshake Receiver] Incorrect data supplied to handshake")
		return HandshakeError{error: "Incorrect data supplied to handshake", code: 403}
	}	
	
	println("[Handshake Receiver] Received handshake request from node claiming to be: $req_parsed.initiator.ref")

	// with this version of the node software all messages should be time objects
	time := time.parse(req_parsed.message) or {
		eprintln("[Handshake Receiver] Incorrect time format supplied to handshake by node claiming to be $req_parsed.initiator.ref")
		return HandshakeError{error: "Incorrect time format supplied to handshake", code: 403}
	}

	println("[Handshake Receiver] Time parsed correctly as: $time")

	config := configuration.get_config()
	keys := cryptography.get_keys(config.key_path)

	res := HandshakeResponse{
		responder_key: keys.pub_key
		initiator: req_parsed.initiator
		message: req_parsed.message
		signature: keys.sign(req_parsed.message.bytes())
	}

	// now need to figure out where message came from and respond back to it
	if !db.aware_of(req_parsed.initiator.ref) {
		println("\n[Handshake Receiver] Node has not come into contact with initiator before, sending them a handshake request")
		// send a handshake request to the node
		go start_handshake_http(req_parsed.initiator.ref, config, db)
	} else {
		println("[Handshake Receiver] Node has come into contact with initiator before, no need to send a handshake request")
	}

	println("[Handshake Receiver] Handshake Analysis Complete. Sending response...")

	return res
}