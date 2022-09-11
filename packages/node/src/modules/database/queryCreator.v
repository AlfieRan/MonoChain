module database

import pg

pub fn table_exists(table string, db pg.DB) bool {
	exists := db.exec("SELECT EXISTS ( SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = '$table');") or {
		println('[Database] Error occoured while checking if table $table exists. $err')
		return false
	}[0].vals[0] == 't'

	if exists {
		println('[Database] Table $table exists.')
	} else {
		println('[Database] Table $table does not exist.')
	}

	return exists
}