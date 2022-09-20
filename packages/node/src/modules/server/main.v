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
	api := go vweb.run(app, config.port) // start server on a new thread

	// initiate entry point to network
	println("[Server] Initiating entry point to network")
	if config.self.public {
		println("[Server] Public node, connecting to $config.entrypoint.http_ref using http")
		time.sleep(2 * time.second) // wait to make sure api server is up properly
		start_handshake_http(config.entrypoint.http_ref, config, db) // ping running node using handshake to verify cryptography is working
	} else {
		println("[Server] Private node, connecting to $config.entrypoint.ws_ref  using ws")
		ws.connect(config.entrypoint.ws_ref)
	}

	println("[Api Server] Initial setup finished, returning to main thread")
	api.wait()	// bring server process back to main thread
}


pub fn (mut app App) index() vweb.Result {
	return app.text("This is the api route for a node running on the Monochain network. To get to the dashaboard, go to /dashboard")
}

