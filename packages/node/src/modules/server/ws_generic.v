module server

// internal
import database
import configuration

// external
import net.websocket
import json

struct WS_Error {
	code int
	info string
}

struct WS_Success {
	info string
}

type WS_Object = Broadcast_Message | WS_Error | WS_Success

// websocket server

struct Websocket_Server {
	is_client bool	[required]
	db database.DatabaseConnection	[required]
	mut:
		c Client
		s Server
}

pub fn (mut ws Websocket_Server) send_to_all(msg string) bool {
	println("[Websockets] Sending message to all clients...")
	if ws.is_client {
		println("[Websockets] Sending messages as a client...")
		return ws.c.send_to_all(msg)
	} else {
		println("[Websockets] Sending messages as a server...")
		return ws.s.send_to_all(msg)
	}
	return false
}

pub fn (mut ws Websocket_Server) connect(ref string) bool {
	println("[Websockets] Connecting to server $ref")
	if ws.is_client {
		println("[Websockets] Connecting as a client...")
		return ws.c.connect(ref)
	} else {
		println("[Websockets] Cannot connect as a server, only clients can connect to servers.")
		return false
	}

	return false
}

pub fn (mut ws Websocket_Server) listen() {
	if !ws.is_client {
		println("[Websockets] Listening for connections...")
		ws.s.listen()
	} else {
		println("[Websockets] Cannot listen as a client, only servers can listen for connections.")
		return
	}
}

// generic functions

pub fn gen_ws_server(db database.DatabaseConnection, config configuration.UserConfig) Websocket_Server {
	if config.self.public {
		println("[Websockets] Node is public, starting server...")
		return Websocket_Server{
			is_client: false,
			db: db,
		 	s: start_server(db, config)
		}
	} else {
		println("[Websockets] Node is private, starting client...")
		return Websocket_Server{
			is_client: true,
			db: db,
		 	c: start_client(db, config)
		}
	}


	eprintln("[Websockets] Error starting websocket server.")
	exit(1)
}

fn on_message(mut ws websocket.Client, msg &websocket.Message, mut obj &Websocket_Server) ? {
	println('[Websockets] Received message: $msg')
	match msg.opcode {
		.text_frame {
			parsed_msg := json.decode(WS_Object, msg.payload.str()) or {
				eprintln('[Websockets] Could not parse message: $err')
				return
			}

			if parsed_msg is Broadcast_Message {
				println('[Websockets] received broadcast message: $parsed_msg')
				valid := broadcast_receiver(obj.db, mut obj, parsed_msg)

				if valid == .ok {
					println('[Websockets] Broadcast message was valid')
					send_ws(mut ws, json.encode(WS_Success{"Broadcast message was valid"}))				
				} else {
					println('[Websockets] Broadcast message was invalid')
					send_ws(mut ws, json.encode(WS_Error{1, "Broadcast message was invalid"}))
				}
			} else if parsed_msg is WS_Success {
				println("[Websockets] Received success message: $parsed_msg.info")
			} else if parsed_msg is WS_Error { 
				eprintln('[Websockets] Received error message: $parsed_msg.info')
			} else {
				eprintln('[Websockets] Received unknown message: $parsed_msg')
			}
		}
		else {
			println('[Websockets] received unknown message: $msg')
		}
	}
}

fn send_ws(mut ws websocket.Client, msg string) bool {
	ws.write_string(msg) or {
		eprintln('[Websockets] Could not send message: $err')
		return false
	}
	return true
}

