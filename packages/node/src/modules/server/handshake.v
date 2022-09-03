module server

// internal imports
import configuration
import cryptography
import memory

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

['/handshake'; post]
pub fn (mut app App) handshake_route() vweb.Result {
	body := app.req.data

	req_parsed := json.decode(HandshakeRequest, body) or {
		eprintln("Incorrect data supplied to /handshake/")
		return app.server_error(403)	
	}

	println("Received handshake request from node claiming to be: $req_parsed.initiator.ref")

	// with this version of the node software all messages should be time objects
	time := time.parse(req_parsed.message) or {
		eprintln("Incorrect time format supplied to handshake by node claiming to be $req_parsed.initiator.ref")
		// this is where we would then store a record of the node's claimed public key
		// after doing so, send back another handshake and if the node really is that node,
		// then store a slight negative grudge
		// otherwise, store the ip address of the node and blacklist it for a while
		return app.server_error(403)
	}

	// time was okay, so store a slight positive grudge
	println("Time parsed correctly as: $time")

	config := configuration.get_config()
	keys := cryptography.get_keys(config.key_path)
	refs := memory.get_refs(config.ref_path)

	res := HandshakeResponse{
		responder_key: keys.pub_key
		initiator: req_parsed.initiator
		message: req_parsed.message
		signature: keys.sign(req_parsed.message.bytes())
	}

	data := json.encode(res)
	println("Handshake Analysis Complete. Sending response...")
	// now need to figure out where message came from and respond back to it
	if !refs.aware_of(req_parsed.initiator.ref) {
		println("Node has not come into contact with initiator before, sending them a handshake request")
		// send a handshake request to the node
		start_handshake(req_parsed.initiator.ref, config)
	} else {
		println("Node has come into contact with initiator before, no need to send a handshake request")
	}

	return app.text(data)
}


pub fn start_handshake(ref string, this configuration.UserConfig) bool {
	// ref should be an ip or a domain
	msg := time.now().format_ss_micro() // set the message to the current time since epoch
	// msg := "invalid data" // Invalid data used for testing
	req := HandshakeRequest{initiator: Initiator{key: this.self.key, ref: this.self.ref}, message: msg}

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
	config := configuration.get_config()
	mut refs := memory.get_refs(config.ref_path)

	// signed hash can then be verified using the wallet pub key supplied
	if data.message == msg && data.initiator.key == this.self.key {
		if cryptography.verify(data.responder_key, data.message.bytes(), data.signature) {
			println("Verified signature to match handshake key\nHandshake with $ref successful.")

			// now add them to reference list
			refs.add_key(ref, data.responder_key)
			return true
		}
		println("Signature did not match handshake key, node is not who they claim to be.")
		// this is where we would then store a record of the node's reference/ip address and temporarily blacklist it
		refs.add_blacklist(ref)
		return false
	}

	println("Handshake was not valid, node is not who they claim to be.")
	println(data)
	// node is not who they claim to be, so store their reference/ip address and temporarily blacklist it
	refs.add_blacklist(ref)
	return false
}
