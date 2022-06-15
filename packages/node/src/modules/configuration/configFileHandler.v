module configuration
import json
import os

pub fn load_config() UserConfig {
	if os.exists("./node.config") { // check config file exists
		// if it does, make sure we can open and decode it

		config_raw := os.read_file("node.config") or {
			// something went wrong opening the file, return without loading the config
			eprintln('Failed to open config file, error $err')
			return UserConfig{ loaded: false }
		}

		user_config := json.decode(UserConfig, config_raw) or {
			// something went wrong decoding the file, return without loading the config
			eprintln('Failed to decode json, error: $err')
			return UserConfig{ loaded: false }
		}

		return user_config // config loaded and no issues with it
	}

	return UserConfig{ loaded: false } // config doesn't exit, so return
} 

pub fn save_config(config UserConfig, recursion_depth int) bool {
	mut failed := false // initialise a failsafe
	data := json.encode(config) // encode the current configuration to json

	os.write_file("./node.config", data) or { // try and write data to file
		// if it failed, run the recursion depth checker to ensure there hasn't been too many failed attempts
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