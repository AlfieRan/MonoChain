module server

// internal imports
import configuration
import database

// external imports
import vweb
import time

// const init_http_ref = "https://nano.monochain.network"
// const init_ws_ref = "wss://nano.monochain.network"
// const init_http_ref = "http://192.168.1.20:8000"
// const init_http_ref = "http://192.168.170.24:8000"
const init_http_ref = "http://nano:8000"
const init_ws_ref = "ws://nano:8001"

struct App {
	vweb.Context
	mut:
		db database.DatabaseConnection
		ws Websocket_Server
}
 
pub fn start(config configuration.UserConfig) {
	// create database connection
	db := database.connect()
	mut ws := gen_ws_server(db, config)

	// start http server
	println("[Server] Starting http server")
	app := App{db: db, ws: ws}
	api := go vweb.run(app, config.port) // start server on a new thread

	// start websocket server
	// println("[Server] Starting Websocket server")
	// start_ws_server()
	// start_client()

	
	// initiate entry point to network
	println("[Server] Initiating entry point to network")
	if config.self.public {
		println("[Server] Public node, connecting to $init_http_ref using http")
		time.sleep(2 * time.second) // wait to make sure api server is up properly
		server.start_handshake_http(init_http_ref, config, db) // ping running node using handshake to verify cryptography is working
	} else {
		println("[Server] Private node, connecting to $init_ws_ref using ws")
		ws.connect(init_ws_ref)
	}

	println("[Api Server] Initial setup finished, returning to main thread")
	api.wait()	// bring server process back to main thread
}


pub fn (mut app App) index() vweb.Result {
	return app.text("This is the api route for a node running on the Monochain network. To get to the dashaboard, go to /dashboard")
}

