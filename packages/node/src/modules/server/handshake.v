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

type HandshakeAssembleResult = string | bool

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

pub fn assemble_handshake(ref string, this configuration.UserConfig, db database.DatabaseConnection, msg string) HandshakeAssembleResult {
	println("[Handshake Requester] Start Handshake initiated")
	if ref == this.self.http_ref || ref == this.self.ws_ref {
		println("[Handshake Requester] Sending a request to self, waiting to prevent feedback loops")
		time.sleep(1 * time.second) // wait to make sure not to loop self 


		if db.aware_of(ref) {
			println("[Handshake Requester] Handshake no longer needed, aborting")
			// if another handshake request has occoured during the waiting period and overrights this one
			return false
		}
	}

	// ref should be an ip or a domain
	
	// msg := "invalid data" // Invalid data used for testing
	req := HandshakeRequest{initiator: Initiator{key: this.self.key, ref: this.self.http_ref}, message: msg}


	println("[Handshake Requester] Sending handshake request to ${ref}.\n[Handshake Requester] Message: $msg")
	// fetch domain, domain should respond with their wallet pub key/address, "pong" and a signed hash of the message
	req_encoded := json.encode(req)
	return req_encoded
}

pub fn verify_handshake_response(data HandshakeResponse, msg string, this configuration.UserConfig) bool {
	// signed hash can then be verified using the wallet pub key supplied
	if data.message == msg && data.initiator.key == this.self.key {
		if cryptography.verify(data.responder_key, data.message.bytes(), data.signature) {
			println("[Handshake Requester] Verified signature to match handshake key\n[Handshake Requester] Handshake successful.")
			// now add them to reference list
			return true
		}
		println("[Handshake Requester] Signature did not match handshake key, node is not who they claim to be.")
		// this is where we would then store a record of the node's reference/ip address and temporarily blacklist it
		return false
	}

	println("[Handshake Requester] Handshake was not valid, node is not who they claim to be.")
	println("[Handshake Requester] $data")
	// node is not who they claim to be, so store their reference/ip address and temporarily blacklist it
	return false
}

type HandshakeTransmitterResult = HandshakeResponse | bool

pub fn send_handshake_packet_http(req_encoded string, ref string) HandshakeTransmitterResult {
	raw := http.post("$ref/handshake", req_encoded) or {
		eprintln("[Handshake Requester] Failed to shake hands with $ref, Node is probably offline. Error: $err")
		return false
	}

	if raw.status_code != 200 {
		eprintln("[Handshake Requester] Failed to shake hands with $ref, may have sent incorrect data, repsonse body: $raw.body")
		return false
	}

	data := json.decode(HandshakeResponse, raw.body) or {
		eprintln("[Handshake Requester] Failed to decode handshake response, responder is probably using an old node version.\nTheir Response: $raw")
		return false
	}

	return data
}

pub fn start_handshake_http(ref string, this configuration.UserConfig, db database.DatabaseConnection) bool {
	println("[Handshake Requester] Starting Handshake over HTTP")
	msg := time.now().format_ss_micro() // set the message to the current time since epoch
	req_encoded := assemble_handshake(ref, this, db, msg)

	if req_encoded is string {
		data := send_handshake_packet_http(req_encoded, ref)

		if data is HandshakeResponse {
			
			println("[Handshake Requester] $ref responded to handshake.")
			verified := verify_handshake_response(data, msg, this)

			if verified {
				println("[Handshake Requester] Completed handshake")
				println("[Handshake Requester] Adding ref to refs")
				db.create_ref(ref, data.responder_key)
				println("[Handshake Requester] Handshake Request Finished")

				return true
			}
		}
	}
	return false
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