module server

// internal
import database
import configuration

// external
import net.websocket
import log

struct Server {
	db database.DatabaseConnection	[required]
	config configuration.UserConfig [required]
	mut: 	
		sv websocket.Server	[required]
}

pub fn start_server(db database.DatabaseConnection, config configuration.UserConfig) Server {
	mut sv := websocket.new_server(.ip, config.port, "", websocket.ServerOpt{
		logger: &log.Logger(&log.Log{
			level: .info
		})
	})
	mut s := Server{db, config, sv}


	println("[Websockets] Server started on port $config.ws_port, setting up handlers...")
	s.sv.on_message_ref(on_message, &s)
	s.sv.listen() or {
		eprintln("[Websockets] Error listening for new connections: $err")
		exit(1)
	}

	if !s.status_check() {
		eprintln("[Websockets] WARNING - Error checking server status, may due to server starting slowly but if this persists, there may be an issue with the server.")
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

pub fn (mut S Server) status_check() bool {
	println("[Websockets] Checking server is running")
	mut cl := websocket.new_client("ws://localhost:$S.config.ws_port", websocket.ClientOpt{
		logger: &log.Logger(&log.Log{
			level: .info
		})
	}) or {
		eprintln("[Websockets] Failed to connect to server")
		return false
	}

	cl.ping() or {
		eprintln("[Websockets] Failed to ping server")
		return false
	}

	return true
}
