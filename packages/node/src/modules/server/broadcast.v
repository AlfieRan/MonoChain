module server

// internal
import database
import cryptography
import configuration

// external
import json
import vweb
import time
import net.http

struct Broadcast_Message_Contents {
	data	string
	time	string
}

struct Broadcast_Message {
	sender	[]u8
	signature []u8
	message	Broadcast_Message_Contents
}

['/broadcast'; post]
pub fn (mut app App) broadcast_route() vweb.Result {
	db := app.db
	body := app.req.data

	decoded := json.decode(Broadcast_Message, body) or {
		eprintln("[Broadcaster] Message received that cannot be decoded: $body")
		return app.server_error(403)
	}

	valid_message := cryptography.verify(decoded.sender, json.encode(decoded.message).bytes(), decoded.signature)

	// check to see if we have received message before, and if so, ignore it.
	// if not then continue on.

	if valid_message {
		println("\n[Broadcaster] Received message:\n[Broadcaster] User: $decoded.sender\n[Broadcaster] Received at: $decoded.message.time\n[Broadcaster] Message: $decoded.message.data")
		forward_to_all(db, decoded)
		return app.ok("ok")
	} else {
		eprintln("[Broadcaster] Received an invalid message")
		return app.server_error(403)
	}

	println("[Broadcaster] Shouldn't have reached this part of the code - please report as a bug.")
	return app.server_error(403)
}

pub fn forward_to_all(db database.DatabaseConnection, msg Broadcast_Message) {
	println("[Broadcaster] Would now forward to references, needs implementing")

	refs := sql db.connection {
		select from database.Reference_Table
	}

	for ref in refs {
		go send(ref.domain, ref.ws, msg)
	}
}

pub fn send(ref string, ws bool, msg Broadcast_Message) bool {
	println("[Broadcaster] Attempting to send message to $ref")
	if ws {
		eprintln("[Broadcaster] Websockets are not implemented yet, cannot send message.")
		return false
	}

	raw_response := http.post("$ref/broadcast", json.encode(msg)) or {
		eprintln("[Broadcaster] Failed to send a message to $ref, Node is probably offline. Error: $err")
		return false
	}

	if raw_response.status_code != 200 {
		eprintln("[Broadcaster] $ref responded to message with an error. Code: $raw_response.status_code")
		return false
	}

	println("[Broadcaster] Successfully Sent message to $ref")
	return true
}

pub fn send_message(db database.DatabaseConnection, data string) {
	println("[Broadcaster] Assembling message with data: $data")
	contents := Broadcast_Message_Contents{
		time: time.now().format_ss_micro()
		data: data
	}

	config := configuration.get_config()
	keys := cryptography.get_keys(config.key_path)

	message := Broadcast_Message{
		sender: config.self.key
		signature: keys.sign(json.encode(contents).bytes())
		message: contents
	}

	println("[Broadcaster] Message assembled, broadcasting to refs...")
	forward_to_all(db, message)
}
