module server

// internal imports
import configuration
import database

// external imports
import vweb
import time

struct App {
	vweb.Context
	mut:
		db database.DatabaseConnection [required]
		ws Websocket_Server [required]
}
 
pub fn start(config configuration.UserConfig) {
	// create database connection
	println("[Server] Connecting to database...")
	println("[Server] Database is external: $config.db_config.run_seperate")
	println("[Server] Database host: $config.db_config.config.host")
	db := database.connect(config.db_config.run_seperate, config.db_config.config)
	mut ws := gen_ws_server(db, config)

	// start http server
	println("[Server] Starting http server")
	app := App{db: db, ws: ws}
	api := go vweb.run(app, config.ports.http) // start server on a new thread

	if !config.advanced.bypass_entry {
		// initiate entry point to network
		println("[Server] Initiating entry point to network")
		if !config.self.public {
			println("[Server] Private node, connecting to $config.entrypoint.ws_ref using ws")
			ws.connect(config.entrypoint.ws_ref)
		} else {
			println("[Server] Public node, connecting using http.")
			time.sleep(2 * time.second) // wait to make sure api server is up properly
			println("[Server] Starting http handshake with entrypoint")
			start_handshake_http(config.entrypoint.http_ref, config, db) // ping running node using handshake to verify cryptography is working
		}

		println("[Api Server] Initial setup finished.")
	} else {
		println("[Server] WARNING - Ignoring entrypoint, this is highly recommended against as it will not connect your node to the network and can be changed in your config file.")
	}

	
	println("[Server] Switching to ws server and listening for incoming connections")
	ws.listen() // start listening for incoming connections
	api.wait()	// bring server process back to main thread
}


pub fn (mut app App) index() vweb.Result {
	return app.text("This is the api route for a node running on the Monochain network. To get to the dashaboard, go to /dashboard")
}

