module database

import time

pub fn (db DatabaseConnection) aware_of(input_domain string) bool {
	println("[Database] Checking if domain $input_domain is in database")
	http_matches := sql db.connection {
		select from Http_Reference where domain == input_domain order by last_connected limit 2
	}

	if http_matches.len > 0  {
		println("[Database] Found a reference to $input_domain")
		return true
	}

	println("[Database] No reference to $input_domain found.")
	return false
}

pub fn (db DatabaseConnection) get_key_http(input_domain string) []u8 {
	ref := sql db.connection {
		select from Http_Reference where domain == input_domain order by last_connected limit 1
	}

	return ref.key.bytes()
}


pub fn (db DatabaseConnection) create_ref(input_domain string, pubkey []u8) bool {
	println("[Database] Checking if a reference to $input_domain already exists")
	if db.aware_of(input_domain) {
		println("[Database] Reference to $input_domain already exists, updating it...")
		db.submit_update(input_domain, pubkey)
		return true
	}

	println("[Database] Creating reference for $input_domain")
	db.submit_create(input_domain, pubkey)
	println("[Database] Reference created successfully")
	return true
}


fn (db DatabaseConnection) submit_create(input_domain string, pubkey []u8)  {
	key_str := pubkey.str()
	println("[Database] Creating http reference for $input_domain")
	ref := Http_Reference{
		domain: input_domain
		key: key_str
	}
	sql db.connection {
		insert ref into Http_Reference
	}
	
}

fn (db DatabaseConnection) submit_update(input_domain string, pubkey []u8)  {
	cur_time := time.utc()
	key_str := pubkey.str()

	println("[Database] Updating http reference for $input_domain")
	sql db.connection {
		update Http_Reference set key = key_str, last_connected = cur_time where domain == input_domain
	}
}

pub fn (db DatabaseConnection) get_refs() []Http_Reference {
	http_refs := sql db.connection {
		select from Http_Reference
	}

	return http_refs
}