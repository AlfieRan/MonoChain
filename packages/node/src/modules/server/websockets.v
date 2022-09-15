module server

// internal
import database

// external
import net.websocket
import json

type WS_Object = Broadcast_Message | HandshakeRequest

fn start_ws(db database.DatabaseConnection) {
	println('[websockets] starting client')
	uri := 'ws://localhost:8001/'
	mut ws := websocket.new_client(uri) or {
		eprint('[websockets] Could not connect to $uri')
		return
	}
	ws.on_message_ref(on_client_message, &db)
	ws.connect() or {
		eprintln('[websockets] Failed to connect to $uri due to $err')
	}
	go ws.listen()
	return
}

fn on_client_message(mut ws websocket.Client, msg &websocket.Message, db &database.DatabaseConnection) ? {
	println('[websockets] received message: $msg')
	match msg.opcode {
		.text_frame {
			parsed_msg := json.decode(WS_Object, msg.payload.str()) or {
				eprintln('[websockets] Could not parse message: $err')
				return
			}

			if parsed_msg is Broadcast_Message {
				println('[websockets] received broadcast message: $parsed_msg')
				valid := broadcast_receiver(db, parsed_msg)

				if valid == .ok {
					println('[websockets] Broadcast message was valid')
					// should now send a message back confirming
				} else {
					println('[websockets] Broadcast message was invalid')
					// should now send an error message back
				}
			}
		}
		else {
			println('[websockets] received unknown message: $msg')
		}
	}
}