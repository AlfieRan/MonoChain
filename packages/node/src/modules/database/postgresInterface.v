module database

// external imports
import pg
import orm
import v.ast

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


// table constants
struct Table {
	name string
	fields []orm.TableField
}

// the V pg docs are not very clear on how to use the orm module, so most of this is just from the examples
// examples - https://github.com/vlang/v/blob/master/vlib/pg/pg_orm_test.v
const ref_table = Table{
	name: "references"
	fields: [
		orm.TableField{
			name: 'domain'
			typ: ast.string_type_idx
			is_time: false
			default_val: ''
			is_arr: false
			attrs: [
				StructAttribute{
					name: 'primary'
					has_arg: false
					arg: ''
					kind: .plain
				},
				StructAttribute{
					name: 'sql'
					has_arg: true
					arg: 'serial'
					kind: .plain
				},
			]
		}
		orm.TableField{
			name: 'key'
			typ: ast.string_type_idx
			is_time: false
			default_val: ''
			is_arr: false
			attrs: []
		},
	]
}

const msg_table = "messages"




pub fn connect() {
	launch()
	db := pg.connect(config) or {
		eprintln("[Database] Could not connect to database, docker container probably not running.\n[Database] Raw error: $err\n[Database] There is a chance this was due to trying to connect before the database was ready, if so restart the program should fix it.")
		exit(310)
	}
	println("[Database] Connected to database. ($host:$port)")
	
	println("[Database] Creating tables...")
	init_tables(db)
}

pub fn init_tables(db pg.DB) {
	tables := [ref_table]

	for table in tables {
		// check if table exists
		if !table_exists(table.name, db) {
			// create table
			db.create(table.name, table.fields) or {
				eprintln("[Database] Could not create table $table.name\n[Database] Raw error: $err")
				exit(320)
			}
			println("[Database] Created table $table.name")
		}
	}
}