module server
import vweb

struct App {
	vweb.Context
}

pub fn start(port int) {
	vweb.run(&App{}, port)
}

pub fn (mut app App) index() vweb.Result {
	return app.text('Hello World!')
}