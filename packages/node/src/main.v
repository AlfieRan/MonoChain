module main
import server
import configuration
import database

fn main() {
	println('[main] ***** MonoChain Mining Software *****')

	config := configuration.get_config()

	if !config.db_config.run_seperate {
		println("[main] Starting database on a docker container, to change this edit your config...")
		database.launch()
	} else {
		println("[main] Assuming database is already running, to change this edit your config...")
	}

	server.start(config)
}