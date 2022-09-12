module database

pub fn (db DatabaseConnection) table_exists(table string) bool {
	exists := db.connection.exec("SELECT EXISTS ( SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = '$table');") or {
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