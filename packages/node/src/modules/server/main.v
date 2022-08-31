module server

// internal imports
import configuration

// external imports
import vweb
import time


struct App {
	vweb.Context
	config configuration.UserConfig
}
 
pub fn start(config configuration.UserConfig) {
	api := go vweb.run(&App{config: config}, config.port) // start server on a new thread
	
	time.sleep(2 * time.second) // wait to make sure server is up
	server.start_handshake("https://nano.monochain.network", config) // ping running node using handshake to verify cryptography is working
	api.wait()	// bring server process back to main thread
}

pub fn (mut app App) index() vweb.Result {
	return app.text("Hello, World!")
}

