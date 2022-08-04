module configuration
import readline { read_line }
import cryptography
import utils

const defualt = UserConfig{
	loaded: true
	config_version: config_version
	last_connect: 0
	port: 8000

}

pub fn create_configuration() UserConfig {
	key_path_tmp := "$base_path/keys.config"
	config := UserConfig{
		last_connect: 0
		config_version: config_version
		key_path: key_path_tmp
		loaded: true
		self: Node{
			trust: 0,	// this should be collected from blockchain
			ref: "self"
			key: cryptography.get_keys(key_path_tmp).pub_key,
		}
		port: ask_for_port(0)
		memory_cache_path: "$base_path/cache.db"
	}

	save_config(config, 0)
	return config
}

fn ask_for_port(recursion_depth int) int {
	mut port := (read_line("What port would you like to run your node on (default: 8000)?\n$:") or { 
		eprintln("Input failed, please try again")
		utils.recursion_check(recursion_depth, 2)
		return ask_for_port(recursion_depth + 1)
	}).int()

	if port > 65535 || port < 1 {
		eprintln("That port does not exist! You might want to enter a number between 1 and 65535.")
		utils.recursion_check(recursion_depth, 3)
		return ask_for_port(recursion_depth + 1)
	}

	return port
}

