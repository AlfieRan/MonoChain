module server
import os

struct Node_Memory {
	pub:
		connections array[Node_Type]	// nodes that this node is aware of
		wallet	string					// this node's pub key id
		state	Blockchain_State		// the blockchain's current state
}


pub fn load_memory(file_location string) ?Node_Memory {
	if os.exists(file_location){
		// woohooo it exists now do something lol
	}
	return none
}