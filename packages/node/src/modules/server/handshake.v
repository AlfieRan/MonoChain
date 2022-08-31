module server

// internal imports
import configuration
import cryptography

// external imports
import vweb
import json
import time
import net.http

// This is to establish a handshake between two nodes and should be done everytime two nodes connect
pub struct PongResponse {
	pong_key []u8
	ping_key []u8
	message string
	signature []u8
}

pub struct PingRequest {
	ping_key []u8
	message string
}


['/handshake'; post]
pub fn (mut app App) handshake_route() vweb.Result {
	body := app.req.data

	req_parsed := json.decode(PingRequest, body) or {
		eprintln("Incorrect data supplied to /handshake/")
		return app.server_error(403)
	}

	config := configuration.get_config()
	keys := cryptography.get_keys(config.key_path)

	println("Received pong request from node with public key: $req_parsed.ping_key")

	// with this version of the node software all messages should be time objects
	time := time.parse(req_parsed.message) or {
		eprintln("Incorrect time format supplied to /pong/:req by node claiming to be $req_parsed.ping_key")
		// this is where we would then store a record of the node's claimed public key
		// after doing so, send back another handshake and if the node really is that node,
		// then store a slight negative grudge
		// otherwise, store the ip address of the node and blacklist it for a while
		return app.server_error(403)
	}

	// time was okay, so store a slight positive grudge
	println("Time parsed correctly as: $time")

	res := PongResponse{
		pong_key: keys.pub_key
		ping_key: req_parsed.ping_key
		message: req_parsed.message
		signature: keys.sign(req_parsed.message.bytes())
	}

	data := json.encode(res)
	return app.text(data)
}


pub fn start_handshake(ref string, this configuration.UserConfig) bool {
	// ref should be an ip or a domain
	msg := time.now().format_ss_micro() // set the message to the current time since epoch
	// msg := "invalid data" // Invalid data used for testing
	req := PingRequest{ping_key: this.self.key, message: msg}

	println("\nSending ping request to ${ref}.\nMessage: $msg")
	// fetch domain, domain should respond with their wallet pub key/address, "pong" and a signed hash of the message
	req_encoded := json.encode(req)
	
	raw := http.post("$ref/handshake", req_encoded) or {
		eprintln("Failed to ping $ref, Node is probably offline. Error: $err")
		return false
	}

	if raw.status_code != 200 {
		eprintln("Failed to ping $ref, may have sent incorrect data, repsonse body: $raw.body")
		return false
	}

	data := json.decode(PongResponse, raw.body) or {
		eprintln("Failed to decode response, responder is probably using an old node version.\nTheir Response: $raw")
		return false
	}

	println("\n$ref responded to ping request.")

	// signed hash can then be verified using the wallet pub key supplied
	if data.message == msg && data.ping_key == this.self.key {
		if cryptography.verify(data.pong_key, data.message.bytes(), data.signature) {
			println("Verified signature to match pong key\nHandshake with $ref successful.")
			return true
		}
		println("Signature did not match pong key")
		return false
	}

	// if valid, return true, if not return false
	return false
}
