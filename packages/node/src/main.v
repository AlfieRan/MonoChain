module main
import server
import configuration
import database

fn main() {
	println('[Main] ***** MonoChain Mining Software *****')

	println("[Main] Getting configuration settings...")
	config := configuration.get_config()

	if !config.db_config.run_seperate {
		println("[Main] Starting database on a docker container, to change this edit your config...")
		database.launch()
	} else {
		println("[Main] Assuming database is already running externally, to change this edit your config...")
	}

	server.start(config)
}