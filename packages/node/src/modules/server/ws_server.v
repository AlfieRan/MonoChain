module server

// internal
import database
import configuration

// external
import net.websocket

struct Server {
	db database.DatabaseConnection	[required]
	config configuration.UserConfig [required]
	mut: 	
		sv websocket.Server	[required]
}

pub fn start_server(db database.DatabaseConnection, config configuration.UserConfig) Server {
	// make ws port configurable
	mut s := Server{
		sv: websocket.new_server(.ip, config.ws_port, "")
		db: db
		config: config
	}

	println("[Websockets] Server started on port $config.ws_port, setting up handlers...")
	s.sv.on_message_ref(on_message, &s)

	s.sv.on_connect(announce_connection) or {
		eprintln("[Websockets] Error setting up on_connect handler: $err")
	}

	println("[Websockets] Server started on port $config.ws_port, waiting for connections...")
	return s
}

pub fn (mut S Server) send_to(id string, data string) bool {
	println("[Websockets] Sending a message to $id")

	mut cl := S.sv.clients[id] or {
		eprintln("[Websockets] Client $id not found")
		return false
	}

	cl.client.write_string(data) or {
		eprintln("[Websockets] Failed to send data to client $id")
	}

	println("[Websockets] Message sent to $id")
	return true
}

pub fn (mut S Server) send_to_all(data string) bool {
	println("[Websockets] Sending a message to all clients")

	mut threads := []thread bool{}
	for id in S.sv.clients.keys() {
		threads << go S.send_to(id, data)
	}
	
	println("[Websockets] Waiting for all threads to finish")
	threads.wait()
	println("[Websockets] Message sent to all clients")
	return true
}

fn announce_connection(mut c websocket.ServerClient) ?bool {
	println("[Websockets] New connection with id $c.client.id")
	return true
}