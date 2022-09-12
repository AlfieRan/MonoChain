module database

pub fn (db DatabaseConnection) get_message(parsed_signature string, parsed_sender string, parsed_receiver string, time string, data string) []Message_Table {
	existing_message := sql db.connection {
		select from Message_Table where signature == parsed_signature && sender == parsed_sender && receiver == parsed_receiver && timestamp == time && contents == data limit 3
	}
	return existing_message
}
