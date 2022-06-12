module configuration
import readline { read_line }
import utils

pub fn create_configuration() UserConfig {
	config := UserConfig{
		loaded: true
		port: ask_for_port(0)
	}

	save_config(config, 0)
	return config
}

fn ask_for_port(recursion_depth int) int {
	mut port := (read_line("What port would you like to run your node on (default: 8001)?\n$:") or { 
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