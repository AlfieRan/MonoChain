module server

// internal imports
import configuration

// external imports
import vweb
import time

const init_ref = "https://nano.monochain.network"
// const init_ref = "http://localhost:8000"

struct App {
	vweb.Context
}
 
pub fn start(config configuration.UserConfig) {
	api := go vweb.run(&App{}, config.port) // start server on a new thread
	
	time.sleep(2 * time.second) // wait to make sure server is up
	server.start_handshake(init_ref, config) // ping running node using handshake to verify cryptography is working
	api.wait()	// bring server process back to main thread
}

pub fn (mut app App) index() vweb.Result {
	return app.text("This is the api route for a node running on the Monochain network.")
}

