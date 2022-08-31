module server
import vweb
import json
import time
import configuration
import cryptography

struct App {
	vweb.Context
	config configuration.UserConfig
}
 
pub fn start(config configuration.UserConfig) {
	api := go vweb.run(&App{config: config}, config.port) // start server on a new thread
	
	time.sleep(2 * time.second) // wait to make sure server is up
	server.ping("https://nano.monochain.network", config) // ping running node using handshake to verify cryptography is working
	api.wait()	// bring server process back to main thread
}

pub fn (mut app App) index() vweb.Result {
	return app.text("Hello, World!")
}


['/pong'; post]
pub fn (mut app App) pong() vweb.Result {
	body := app.req.data

	req_parsed := json.decode(PingRequest, body) or {
		eprintln("Incorrect data supplied to /pong/")
		return app.server_error(403)
	}

	config := configuration.get_config()
	keys := cryptography.get_keys(config.key_path)

	println("Received pong request from node with public key: $req_parsed.ping_key")

	// with this version of the node software all messages should be time objects
	time := time.parse(req_parsed.message) or {
		eprintln("Incorrect time format supplied to /pong/:req by node claiming to be $req_parsed.ping_key")
		// this is where we would then store a record of the node's claimed public key
		// after doing so, send back another handshake and if the node really is that node,
		// then store a slight negative grudge
		// otherwise, store the ip address of the node and blacklist it for a while
		return app.server_error(403)
	}

	// time was okay, so store a slight positive grudge
	println("Time parsed correctly as: $time")

	res := PongResponse{
		pong_key: keys.pub_key
		ping_key: req_parsed.ping_key
		message: req_parsed.message
		signature: keys.sign(req_parsed.message.bytes())
	}

	data := json.encode(res)
	return app.text(data)
}
