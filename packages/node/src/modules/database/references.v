module database

pub fn (db DatabaseConnection) aware_of(input_domain string) bool {
	domain := sql db.connection {
		select from Reference_Table where key == input_domain order by last_connected limit 2
	}

	return domain.len > 0
}

pub fn (db DatabaseConnection) get_key(input_domain string) []u8 {
	ref := sql db.connection {
		select from Reference_Table where domain == input_domain order by last_connected limit 1
	}

	return ref.key.bytes()
}

pub fn (db DatabaseConnection) create_ref(input_domain string, key []u8, websocket bool) bool {
	ref := Reference_Table{
		domain: input_domain
		key: key.str()
		ws: websocket
	}

	sql db.connection {
		insert ref into Reference_Table
	}

	return true
}
