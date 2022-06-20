module server
import vweb
import json
import configuration
// import time

struct App {
	vweb.Context
}

pub fn start(config configuration.UserConfig) {
	api := go vweb.run(&App{}, config.port)
	// time.sleep(2 * time.second)
	// server.ping("http://localhost:$config.port", config)
	api.wait()
}

pub fn (mut app App) index() vweb.Result {
	return app.text('Hello World!')
}

['/pong/:req']
pub fn (mut app App) pong(req string) vweb.Result {
	req_parsed := json.decode(PingRequest, req) or {
		eprintln("Incorrect data supplied to /pong/:req")
		return app.server_error(403)
	}

	self := configuration.get_config()

	println("Received pong request, data supplied: $req_parsed")

	res := PongResponse{
		pong_key: self.pub_key
		ping_key: req_parsed.ping_key
		message: req_parsed.message
		signature: "signature" // replace this with the "sign" function call once I've actually made it
	}

	data := json.encode(res)
	return app.text(data)
}