module server

// internal imports
import configuration
import memory

// external imports
import vweb
import time
import json

const init_ref = "https://nano.monochain.network"
// const init_ref = "http://localhost:8000"


struct App {
	vweb.Context
	refs shared memory.References
}
 
pub fn start(config configuration.UserConfig) {
	app := App{refs: memory.get_refs(config.ref_path)}
	api := go vweb.run(app, config.port) // start server on a new thread
	
	
	time.sleep(2 * time.second) // wait to make sure server is up
	server.start_handshake_http(init_ref, config) // ping running node using handshake to verify cryptography is working
	println("[Api Server] Initial handshake finished, returning to main thread")
	api.wait()	// bring server process back to main thread
}

["/test"]
pub fn (mut app App) test() vweb.Result {
	println(app)
	mut result := ""
	lock app.refs {
		cur := app.refs
		result = json.encode(cur)
	}
	return app.text(result)
}

pub fn (mut app App) index() vweb.Result {
	return app.text("This is the api route for a node running on the Monochain network.")
}

