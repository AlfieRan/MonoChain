module server
import configuration
import json
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
	msg := "gfhajbsfhka" // should be random or datetime or something
	req := PingRequest{ping_key: this.self.key, message: msg}

	println("Sending ping request to $ref")
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

	println("$ref responded to ping request with pong $data")

	// signed hash can then be verified using the wallet pub key supplied
	if data.message == msg && data.ping_key == this.self.key {
		println("Should also verify signature but I haven't implemented DSA yet")
		return true
	}

	// if valid, return true, if not return false
	return false
}
