module database

import time
import rand

pub fn (db DatabaseConnection) aware_of(input_domain string) bool {
	println("[Database] Checking if domain $input_domain is in database")
	matches := sql db.connection {
		select from Reference_Table where domain == input_domain order by last_connected limit 2
	}
	// matches := []Reference_Table{}
	println("[Database] Found $matches.len references to $input_domain")

	return matches.len > 0
}

pub fn (db DatabaseConnection) get_key(input_domain string) []u8 {
	ref := sql db.connection {
		select from Reference_Table where domain == input_domain order by last_connected limit 1
	}

	return ref.key.bytes()
}

pub fn (db DatabaseConnection) create_ref(input_domain string, pubkey []u8, websocket bool) bool {
	println("[Database] Checking if a reference to $input_domain already exists")

	key_str := pubkey.str()

	if db.aware_of(input_domain) {
		println("[Database] Reference to $input_domain already exists, updating it...")
		cur_time := time.now()
		sql db.connection {
			update Reference_Table set key = key_str, ws = websocket, last_connected = cur_time where domain == input_domain
		}
		return true
	}

	println("[Database] Creating reference for $input_domain")
	ref := Reference_Table{
		id: rand.uuid_v4().int()
		domain: input_domain
		key: key_str
		ws: websocket
	}
	// /opt/homebrew/Cellar/postgresql@14/14.5_3/include

	sql db.connection {
		insert ref into Reference_Table
	}

	return true
}
