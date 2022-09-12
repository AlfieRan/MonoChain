module server

// internal
import database
import cryptography
import configuration

// external
import json
import vweb
import time

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
		forward_to_refs(db, decoded)
		return app.json("ok")
	} else {
		eprintln("[Broadcaster] Received an invalid message")
		return app.server_error(403)
	}

	println("[Broadcaster] Shouldn't have reached this part of the code - please report as a bug.")
	return app.server_error(403)
}

pub fn forward_to_refs(db database.DatabaseConnection, msg Broadcast_Message) {
	println("[Broadcaster] Would now forward to references, needs implementing")
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
	forward_to_refs(db, message)
}
