module server

// internal
import database
import configuration

// external
import net.websocket
import log
import time

struct Server {
	db database.DatabaseConnection	[required]
	config configuration.UserConfig [required]
	mut: 	
		sv websocket.Server	[required]
}

pub fn start_server(db database.DatabaseConnection, config configuration.UserConfig) Server {
	mut sv := websocket.new_server(.ip, config.ws_port, "", websocket.ServerOpt{
		logger: &log.Logger(&log.Log{
			level: .info
		})
	})
	mut s := Server{db, config, sv}

	println("[Websockets] Server initialised on port $config.ws_port, setting up handlers...")
	sv.on_message_ref(on_message, &s)
	
	

	println("[Websockets] Server setup on port $config.ws_port, ready to launch.")
	s.run_server()
	return s
}

pub fn (mut S Server) run_server() {
	println("[Websockets] Launching server...")
	go S.listen()
	println("[Websockets] Server started listening on a new thread, waiting 2 seconds to ensure it's ready to proceed...")
	time.sleep(2 * time.second)
	return
}

pub fn (mut S Server) listen() {
	S.sv.listen() or {
		eprintln("[Websockets] ERROR - Error listening on server: $err")
		exit(1)
	}
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

