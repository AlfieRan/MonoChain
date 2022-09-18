module server

import database
import configuration

import net.websocket

// don't need to store ws references in db because they get wiped on server restart

struct Client {
	db database.DatabaseConnection	[required]
	config configuration.UserConfig [required]
	mut:
		connections map[string]websocket.Client
}

pub fn start_client(db database.DatabaseConnection, config configuration.UserConfig) Client {
	c := Client{
		db: db
		config: config
		connections: map[string]websocket.Client{}
	}

	println("[Websockets] Created client.")

	return c
}

pub fn (mut c Client) connect(ref string) {
	mut ws := websocket.new_client(ref) or {
		eprintln("[Websockets] Failed to connect to $ref\n[Websockets] Error: $err")
		return
	}

	println('[Websockets] Setup Client, initialising handlers... ')
	ws.on_message_ref(on_message, &c)

	c.connections[ws.id] = ws
	println('[Websockets] Connected to $ref')
	return
}

pub fn (mut c Client) send_to(id string, data string) bool {
	println("[Websockets] Sending a message to $id")

	mut ws := c.connections[id] or {
		eprintln("[Websockets] Connection with id $id not found")
		return false
	}

	ws.write_string(data) or {
		eprintln("[Websockets] Failed to send data to $id\n[Websockets] Error: $err")
		return false
	}

	println("[Websockets] Message successfully sent to $id")
	return true
}

pub fn (mut c Client) send_to_all(data string) bool {
	println("[Websockets] Sending a message to all clients")
	mut threads := []thread bool{}

	for id in c.connections.keys() {
		println("[Websockets] Starting a new thread to send a message to $id")
		threads << go c.send_to(id, data)
	}

	println("[Websockets] Waiting for all threads to finish")
	threads.wait()
	println("[Websockets] All threads finished, message sent.")
	return true
}