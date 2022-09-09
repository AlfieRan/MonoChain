module main
import server
import configuration

fn main() {
	println('[main] ***** MonoChain Mining Software *****')
	config := configuration.get_config()
	server.start(config)
	// server.start_ws_server()
}