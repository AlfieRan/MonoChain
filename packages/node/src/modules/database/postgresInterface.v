module database

// external imports
import pg

// config constants
const host = "localhost"
const port = 5432

const config = pg.Config{
	host: host
	port: port
	user: "postgres"
	password: db_password
	dbname: db_name
}


pub struct Reference_Table {
	pub:
		id          int     [primary; sql: serial]	// just for the db
		domain     	string 	[default: '']	// domain of node
		key        	string 	// key that is attached to node
		ws		 	bool 	// ref is a websocket connection
		last_connected 		string	[default: 'CURRENT_TIMESTAMP'; sql_type: 'TIMESTAMP']	// when the reference was last used
}

pub struct Message_Table {
	pub:
		id          int      [primary; sql: serial]	// just for the db
		timestamp  	string 	[default: 'CURRENT_TIMESTAMP'; sql_type: 'TIMESTAMP']	// when the message was sent
		sender     	string	// key of the sender
		receiver   	string	// key of the receiver
		contents   	string 	// conetnts of the message
		signature  	string	// the signature of the message 
}

pub struct DatabaseConnection {
	pub mut:
		connection pg.DB
}

// interfacing with the tables using the pg module
pub fn connect() DatabaseConnection {
		connection := pg.connect(config) or {
		eprintln("[Database] Could not connect to database, docker container probably not running.\n[Database] Raw error: $err\n[Database] There is a chance this was due to trying to connect before the database was ready, if so restart the program should fix it.")
		exit(310)
	}

	db := DatabaseConnection{connection: connection}

	println("[Database] Connected to database. ($host:$port)")
	
	println("[Database] Creating tables...")
	db.init_tables()
	return db
}

pub fn (db DatabaseConnection) init_tables() {
	println("[Database] Creating reference table...")
	sql db.connection {
		create table Reference_Table
	}
	println("[Database] Creating message table...")
	sql db.connection {
		create table Message_Table
	}
	println("[Database] Tables created.\n")
}
