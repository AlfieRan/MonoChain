module configuration
import utils

const config_version = 0 

// Structures and Types

pub struct UserConfig {
	last_connect int	// the last time this node connected to the network
	config_version int
	pub: 
		priv_key []u8
		loaded bool	// has the config loaded up
		port int	// open port for server
		self Node	// ref to self
}

struct Node {
	pub:
		trust int
		ref string
		key []u8
}

// Fundamental Configuration Handlers

pub fn get_config() UserConfig {
	// get the user configuration from the defualt file location
	mut user_config := load_config()

	if !user_config.loaded {
		// if config doesn't exist, ask user to create a new one
		println("No config detected, or error occoured.")
		user_config = new_config(0) // start creating a new config with a recursion depth of 0
	}

	if !user_config.loaded {
		// if config failed to load after attempting to create a new one, exit program
		eprintln("Failed to create a new configuration file, unexpected value was $user_config ")
		exit(100) // exit with code 100
	}

	// return config after it's loaded
	println("\nConfig Loaded...")
	return user_config
}

fn new_config(recursion_depth int) UserConfig {
	// generate a new configuration file

	println('\nWould you like to create a new configuration file (y/n)?\nWARNING - If you already have a config file this will overwrite it!')
	create_new_config_usr := utils.ask_for_bool(0) // make sure the user wants to generate a new file

	if create_new_config_usr { // user confirmed
		// start creating the new file
		println("\nCreating new configuration file...")
		return create_configuration() // create the new configuration and return it

	} else { //user denied
		// user requested to not create a new config file, so exit the program.
		println("Cancelling...\nCannot launch without configuration file, exiting program.")
		exit(0) // exit with code 0, because program cannot run without a config
	}
}

pub fn get_private_key() []u8 {
	user_config := load_config()

	if !user_config.loaded {
		// if config doesn't exist, ask user to create a new one
		println("No config detected, or error occoured.")
		exit(75) // start creating a new config with a recursion depth of 0
	}

	return user_config.priv_key
}