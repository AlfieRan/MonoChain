import database
import pg

fn test_shell() {
	cmd := 'echo "hello world"'
	assert database.sh(cmd)

}

fn test_db_launch() {
	database.launch()
	// this test will crash if it fails
	assert true
}

fn test_db_stop() {
	database.launch()
	database.stop()
	// this test will crash if it fails
	assert true
}

fn test_db_connection() {
	database.launch()
	db := database.connect(false, pg.Config{})
	database.stop()
	// this test will crash if it fails
	assert true
}

fn test_messages() {
	eprintln("WARNING - THIS TEST RELIES ON THE DATABASE HAVING ATLEAST 1 MESSAGE, IF IT DOES NOT, IT WILL FAIL")
	database.launch()
	db := database.connect(false, pg.Config{})
	messages := db.get_latest_messages(0, 5)
	database.stop()
	// this test will crash if it fails
	assert messages.len > 0
}

fn test_create_ref() {
	database.launch()
	db := database.connect(false, pg.Config{})
	create_test_ref(db)
	database.stop()
	// this test will crash if it fails
	assert true
}

fn test_aware_ref() {
	database.launch()
	db := database.connect(false, pg.Config{})
	create_test_ref(db)
	aware := db.aware_of('test')
	database.stop()
	assert aware
}

fn test_refs() {
	database.launch()
	db := database.connect(false, pg.Config{})
	create_test_ref(db)	// create a ref if the test one doesn't already exist
	refs := db.get_refs()
	database.stop()
	assert refs.len > 0
}

fn create_test_ref(db database.DatabaseConnection) {
	mut aware := db.aware_of('test')

	if !aware {
		// just in case the test ref doesn't exist
		db.create_ref('test', 'test'.bytes())
		aware = db.aware_of('test')
	}
}
