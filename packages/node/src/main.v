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

// import vweb

// const content = '|   __    __
// |  / \\\\..// \\\n|    ( oo )
// |     \\__/
// |
// |
// |  software engineer
// |
// |  hi@alistair.sh
// |  https://twitter.com/alistaiiiir
// |  https://alistair.sh
// |  served by {{hop-edge-node}}@hop.io
// '

// struct App {
//     vweb.Context
// }

// fn main() {
//     vweb.run_at(&App{}, vweb.RunParams{
//         port: 8000
//     }) or {
//         panic(err)
//     }
// }

// pub fn (mut app App) index() vweb.Result {
//     node := app.req.header.get_custom('x-hop-edge-node') or { 'local' }

//     println(node)

//     return app.text(content.replace('{{hop-edge-node}}', node))
// }