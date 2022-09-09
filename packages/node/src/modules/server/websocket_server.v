module server

import net.websocket


pub fn start_ws_server() {
	println("[websockets] Starting server...")
	mut server := websocket.new_server(.ip6, 8001, '/ws')
	go server.listen()
	server.on_message(on_message)
	start_client()
}

pub fn on_message(mut ws websocket.Client, msg &websocket.Message) ? {
	if msg.opcode == .text_frame {
		text := msg.payload.bytestr()
		println('[websockets] Received message: $text')
		println("[websockets] $ws.id")
	}
}
