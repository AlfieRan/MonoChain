module server
import os
import json

struct Node_Memory {
	pub:
		connections array[Node_Type]	// nodes that this node is aware of
		state	Blockchain_State		// the blockchain's current state
}


pub fn load_memory(file_location string) ?Node_Memory {
	mut failed := false

	if os.exists(file_location){
		raw_data := os.read_file(file_location) or {
			eprintln("file: $file_location failed to read.\nError: $err")
			failed = true
			return none
		}

		if !failed {
			parsed_data := json.decode(Node_Memory, raw_data) or {
				eprintln("file: $file_location failed to parse.\nError: $err")
				failed = true
				return none
			}

			if !failed { return parsed_data }
		}
	} else {
		failed = true
	}

	if !failed {
		println("Failed to return data but no failures have occoured - load_memory in memory.v - PLEASE REPORT TO DEV")
		exit(4)
	}

	// No local memory so we have to assemble it using other node's memory

	// 1. We need the user to input their public and private key
	// 2. verify that the pub and priv key combo work by signing and verifying some data
	// 3. get the entry point to the network from the user config (first node they will connect to)
	// 4. request up to 1000 nodes from entry point
	// 5. ask these nodes for the last 10 blocks
	// 6. compare and find the newest block that the majority of them agree on
	// 7. get the state hash from this block
	// 8. ask a node for the state tree
	// 9. verify it with the state hash
	// 10. if it doesn't verify go back to step 8
	// 11. load this data into the memory
	// 12. return function

	return none
}