module database

// external imports
import pg

// config constants
const host = "localhost"
const port = 5432

// table constants
const ref_table = "references"


// sql queries


const config = pg.Config{
	host: host
	port: port
	user: "postgres"
	password: db_password
	dbname: db_name
}

pub fn connect() {
	launch()
	db := pg.connect(config) or {
		eprintln("[Database] Could not connect to database, docker container probably not running.\n[Database] Raw error: $err\n[Database] There is a chance this was due to trying to connect before the database was ready, if so restart the program should fix it.")
		exit(310)
	}
	println("[Database] Connected to database. ($host:$port)")
	
}