module main
import server
import configuration

fn main() {
	println('***** MonoChain Mining Software *****')
	config := configuration.get_config()
	server.start(config)
}
