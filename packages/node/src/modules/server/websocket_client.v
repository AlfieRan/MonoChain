module server

import net.websocket

fn start_client() {
	println('[websockets] starting client')
	uri := 'ws://localhost:8001/'
	mut ws := websocket.new_client(uri) or {
		eprint('[websockets] Could not connect to $uri')
		return
	}
	ws.on_message(on_client_message)
	ws.connect() or {
		eprintln('[websockets] Failed to connect to $uri due to $err')
	}
	go ws.listen()
	println('[websockets] Sending message to server')
	ws.write_string('hello') or {
		eprintln('[websockets] error writing to server: $err')
	}
	return
}

fn on_client_message(mut ws websocket.Client, msg &websocket.Message) ? {
	// autobahn tests expects to send same message back
	println('[websockets] received message: $msg')
}