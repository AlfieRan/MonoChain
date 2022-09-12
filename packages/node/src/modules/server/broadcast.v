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
import rand

struct Broadcast_Message_Contents {
	sender	[]u8
	receiver []u8
	data	string
	time	string
}

struct Broadcast_Message {
	message	Broadcast_Message_Contents
	signature []u8
}

['/broadcast'; post]
pub fn (mut app App) broadcast_route() vweb.Result {
	db := app.db
	body := app.req.data

	decoded := json.decode(Broadcast_Message, body) or {
		eprintln("[Broadcaster] Message received that cannot be decoded: $body")
		return app.server_error(403)
	}

	valid_message := cryptography.verify(decoded.message.sender, json.encode(decoded.message).bytes(), decoded.signature)

	if valid_message {
		println("[Broadcaster] Message received from $decoded.message.sender is valid, checking if seen before...")
		// check if message has been recieved before
		parsed_signature := decoded.signature.str()
		parsed_sender := decoded.message.sender.str()
		parsed_receiver := decoded.message.receiver.str()

		// check if message has been recieved before
		message_seen_before := db.get_message(parsed_signature, parsed_sender, parsed_receiver, decoded.message.time, decoded.message.data).len > 0

		if !message_seen_before {
			println("[Broadcaster] Have not seen message before.\n[Broadcaster] Saving message to database.")
			
			message_db := database.Message_Table{
				id: rand.uuid_v4()
				timestamp: decoded.message.time
				contents: decoded.message.data
				sender: parsed_sender
				receiver: parsed_receiver
				signature: parsed_signature
			}

			sql db.connection {
				insert message_db into database.Message_Table
			}
			println("[Database] Saved message to database.")

			println("\n[Broadcaster] Received message:\n[Broadcaster] Sender: $decoded.message.sender\n[Broadcaster] Received at: $decoded.message.time\n[Broadcaster] Message: $decoded.message.data\n")
			forward_to_all(db, decoded)
			return app.ok("Message received and forwarded.")
		}

		println("[Broadcaster] Have seen message before.")
		return app.ok("Message received but not forwarded.")

	} else {
		eprintln("[Broadcaster] Received an invalid message")
		return app.server_error(403)
	}

	println("[Broadcaster] Shouldn't have reached this part of the code - please report as a bug.")
	return app.server_error(403)
}

pub fn forward_to_all(db database.DatabaseConnection, msg Broadcast_Message) {
	println("[Broadcaster] Sending message to all known nodes.")

	// get all known nodes
	refs := sql db.connection {
		select from database.Reference_Table
	}

	for ref in refs {
		go send(ref.domain, ref.ws, msg)
	}

	println("[Broadcaster] Sent message to all known nodes.")
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

pub fn broadcast_message(db database.DatabaseConnection, data string){
	send_message(db, data, "".bytes())
}

pub fn send_message(db database.DatabaseConnection, data string, receiver []u8) {
	println("[Broadcaster] Assembling message with data: $data")
	config := configuration.get_config()
	keys := cryptography.get_keys(config.key_path)

	contents := Broadcast_Message_Contents{
		sender: config.self.key
		receiver: receiver
		time: time.now().str()
		data: data
	}

	message := Broadcast_Message{
		signature: keys.sign(json.encode(contents).bytes())
		message: contents
	}

	println("[Database] Saving message to database.")
	db_msg := database.Message_Table{
		id: rand.uuid_v4()
		timestamp: contents.time
		sender: contents.sender.str()
		receiver: contents.receiver.str()
		contents: contents.data
		signature: message.signature.str()
	}

	sql db.connection {
		insert db_msg into database.Message_Table
	}
	println("[Database] Message saved.")


	println("[Broadcaster] Message assembled, broadcasting to refs...")
	forward_to_all(db, message)
}
