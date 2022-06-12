module configuration
import json
import os
import readline { read_line }

pub fn load_config() UserConfig {
	if os.exists("./node.config") {
		// config file already exists, make sure we can open and decode it

		config_raw := os.read_file("node.config") or {
			// something went wrong opening the file, return null
			eprintln('Failed to open config file, error $err')
			return UserConfig{ loaded: false }
		}

		user_config := json.decode(UserConfig, config_raw) or {
			// something went wrong decoding the file, return null
			eprintln('Failed to decode json, error: $err')
			return UserConfig{ loaded: false }
		}

		return user_config
	}

	return UserConfig{ loaded: false }
} 

pub fn save_config(config UserConfig, recursion_depth int) bool {
	mut failed := false

	data := json.encode(config)
	if failed {return false}

	os.write_file("./node.config", data) or {
		eprintln('Failed to save file, trying again.')
		if recursion_depth >= 5{
			eprintln("Failed to save file too many times, continuing with program but your config won't be saved")
			failed = true
		} else {
			failed = !save_config(config, recursion_depth + 1)
		}
	}


	if !failed {
		println("Sucessfully saved configuration file.") 
	}
	return !failed
}