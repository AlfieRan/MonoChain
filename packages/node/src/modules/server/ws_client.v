module server

// internal modules
import database
import configuration

// external
import net.websocket
import log


struct Client {
	db database.DatabaseConnection	[required]
	config configuration.UserConfig [required]
	mut:
		connections []websocket.Client
}

pub fn start_client(db database.DatabaseConnection, config configuration.UserConfig) Client {
	c := Client{
		db: db
		config: config
		connections: []websocket.Client{}
	}

	println("[Websockets] Created client.")
	return c
}

pub fn (mut c Client) connect(ref string) bool {
	mut ws := websocket.new_client(ref, websocket.ClientOpt{logger: &log.Logger(&log.Log{
		level: .info
	})}) or {
		eprintln("[Websockets] Failed to connect to $ref\n[Websockets] Error: $err")
		return false
	}

	ws.on_open(socket_opened)
	ws.on_close(socket_closed)
	ws.on_error(socket_error)
	println('[Websockets] Setup Client, initialising handlers... ')
	ws.on_message_ref(on_message, &c)
	ws.connect() or {
		eprintln("[Websockets] Failed to connect to $ref\n[Websockets] Error: $err")
	}
	go ws.listen()

	c.connections << ws
	println('[Websockets] Connected to $ref')
	return true
}

pub fn (mut c Client) send_to_all(data string) bool {
	println("[Websockets] Sending a message to all ${c.connections.len} clients")
	mut threads := []thread bool{}
	for mut connection in c.connections {
		println("[Websockets] Starting a new thread to send a message to $connection.id")
		threads << go send_ws(mut connection, data)
	}

	println("[Websockets] Waiting for all threads to finish")
	threads.wait()
	println("[Websockets] All threads finished, message sent.")
	return true
}

fn socket_opened(mut c websocket.Client) ? {
	println("[Websockets] Socket opened")
}

fn socket_closed(mut c websocket.Client, code int, reason string) ? {
	println("[Websockets] Socket closed, code: $code, reason: $reason")
}

fn socket_error(mut c websocket.Client, err string) ? {
	println("[Websockets] Socket error: $err")
}