module server

// Internal Imports
import configuration
import cryptography

// External Imports
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

pub fn ping(ref string, this configuration.UserConfig) bool {
	// ref should be an ip or a domain
	msg := time.now().format_ss_micro() // set the message to the current time since epoch
	req := PingRequest{ping_key: this.self.key, message: msg}

	println("\nSending ping request to ${ref}.\nRequest: $req")
	// fetch domain, domain should respond with their wallet pub key/address, "pong" and a signed hash of the message
	req_encoded := json.encode(req)
	raw := http.get("$ref/pong/$req_encoded") or {
		eprintln("Failed to ping $ref, Node is probably offline. Error: $err")
		return false
	}

	data := json.decode(PongResponse, raw.body) or {
		eprintln("Failed to decode response, responder is probably using an old node version.\nTheir Response: $raw")
		return false
	}

	println("\n\n$ref responded to ping request.\n Response: ${data} \n")

	// signed hash can then be verified using the wallet pub key supplied
	if data.message == msg && data.ping_key == this.self.key {
		if cryptography.verify(data.pong_key, data.message.bytes(), data.signature) {
			println("Verified signature to match pong key")
			return true
		}
		println("Signature did not match pong key")
		return true
	}

	// if valid, return true, if not return false
	return false
}
