module main
import server
import configuration
import database

fn main() {
	println('[main] ***** MonoChain Mining Software *****')
	database.launch()
	config := configuration.get_config()
	server.start(config)
	// server.start_ws_server()
}