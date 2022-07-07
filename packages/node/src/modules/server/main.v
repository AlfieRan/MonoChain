module server
import vweb
import json
import time
import configuration
import cryptography

struct App {
	vweb.Context
}

pub fn start(config configuration.UserConfig) {
	api := go vweb.run(&App{}, config.port)
	time.sleep(2 * time.second)
	server.ping("http://localhost:$config.port", config)
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

	this := configuration.get_config()

	println("Received pong request.\n data supplied: $req_parsed \n Raw data supplied $req")

	res := PongResponse{
		pong_key: this.self.key
		ping_key: req_parsed.ping_key
		message: req_parsed.message
		signature: cryptography.sign(this.priv_key, req_parsed.message.bytes())
	}

	data := json.encode(res)
	return app.text(data)
}