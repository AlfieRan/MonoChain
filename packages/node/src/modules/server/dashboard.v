module server

// external modules
import vweb
import crypto.rand
import json
import net.http

// internal
import configuration
import utils

const token_path = "$configuration.base_path/tokens.json"

struct MessageInfo {
	pub:
		sender string
		timestamp string
		contents string
}

['/dashboard'; get]
pub fn (mut app App) dashboard_page() vweb.Result {
	if !is_logged_in(app) {
		return app.redirect('/login')
	}

	raw_message_objs := app.db.get_latest_messages(0, 25)
	mut message_objs := []MessageInfo{}

	println("[Dashboard] Got ${raw_message_objs.len} messages from database")
	for msg in raw_message_objs {
		mut sender := ""

		data := json.decode([]u8, msg.sender) or {
			// eprintln("Error decoding JSON of sender: $err")
			sender = msg.sender
			[]u8{}
		}

		for item in data {
			// Big O notation of O(n^2) so not great, but should be a small list
			sender += item.hex()
		}

		message_objs << MessageInfo{
			sender: sender
			timestamp: msg.timestamp
			contents: msg.contents
		}
	}

	return $vweb.html()
}


['/login'; get]
pub fn (mut app App) login_page() vweb.Result {
	if is_logged_in(app) {
		return app.redirect('/dashboard')
	}
	return $vweb.html()
}

['/dashboard/gentoken'; get]
pub fn (mut app App) gentoken_route() vweb.Result {
	config := configuration.get_config()
	// Generate a new token
	token := (rand.int_u64(4294967295) or { return app.server_error(500) }).str()
	cur_tokens := utils.read_file(token_path, true)

	if !cur_tokens.loaded {
		if !utils.save_file(token_path, json.encode([token]), 0) {
			eprintln("[Server] Failed to save token to file.")
		}
	} else {
		mut prev_tokens := json.decode([]string, cur_tokens.data) or {
			eprintln("[Server] Failed to load previous tokens, overwriting...")
			[]string{}
		}
		prev_tokens << token

		if !utils.save_file(token_path, json.encode(prev_tokens), 0) {
			eprintln("[Server] Failed to save token to file.")
		}
	}

	println("\n\n[Server] Generated new token: $token\n[Server] Enter it at http://localhost:$config.ports.http/dashboard to login \n\n")
	
	// Confirm the token has been sent
	return app.ok("ok")
}

['/dashboard/login'; post]
pub fn (mut app App) login_route() vweb.Result {
	data := app.Context.req.data

	prev_tokens_raw := utils.read_file(token_path, true)

	if !prev_tokens_raw.loaded {
		eprintln("[Server] Failed to load token storage.")
		return app.server_error(401)
	}

	prev_tokens := json.decode([]string, prev_tokens_raw.data) or {
		eprintln("[Server] Failed to decode token data.")
		return app.server_error(401)
	}

	if data in prev_tokens {
		println("[Server] Token supplied valid.")
		cookie := http.Cookie{
			name: "token"
			value: data
			max_age: 3600
			secure: false
		}

		app.set_cookie(cookie)
		return app.ok("ok")
	}

	eprintln("[Server] Token supplied not valid.")
	println("[Server] Supplied data $data, tokens available: $prev_tokens")
	return app.server_error(401)
}

['/dashboard/send_message'; post]
pub fn (mut app App) send_message_route() vweb.Result {
	if !is_logged_in(app) {
		return app.server_error(401)
	}

	data := app.Context.req.data
	lock app.ws {
		send_message(app.db, mut app.ws, data, []u8{})
	}
	return app.ok("ok")
}


fn is_logged_in(app App) bool {
	cookie := app.get_cookie('token') or {
			eprintln("[Server] Failed to get cookie. Error: $err")
			return false
		}

	if cookie == '' {
		return false
	}

	prev_tokens_raw := utils.read_file(token_path, true)

	if !prev_tokens_raw.loaded {
		eprintln("[Server] Failed to load token storage.")
		return false
	}

	prev_tokens := json.decode([]string, prev_tokens_raw.data) or {
		eprintln("[Server] Failed to decode token data.")
		return false
	}

	if cookie in prev_tokens {
		println("[Server] Token supplied valid.")
		// now get the node's data and do stuff with it
		return true
	}

	eprintln("[Server] Token supplied not valid.")
	println("[Server] Supplied data $cookie, tokens available: $prev_tokens")
	return false
}