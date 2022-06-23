module configuration
import readline { read_line }
import utils

// Structures and Types

pub struct UserConfig {
	last_connect int	// the last time this node connected to the network
	priv_key string
	pub: 
		pub_key string
		loaded bool	// has the config loaded up
		port int	// open port for server
		self Node	// ref to self
}

struct Node {
	trust int
	ref string
	key string
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

fn ask_for_new_config(recursion_depth int) string {
	// ask the user if they want to create a new configuration file, then convert their response to a lowercaps string

	create_new_config_usr := utils.inp_parser(read_line('\nWould you like to create a new configuration file (y/n)?\nWARNING - If you already have a config file this will overwrite it!\n$:') or {
		// their input failed, could be a program issue or a data input error.
		
		eprintln("Input failed, error $err")
		utils.recursion_check(recursion_depth, 50) // ensure that the recursion depth is not too high, if it is exit with code 50

		return ask_for_new_config(recursion_depth + 1) // otherwise try again with an increased recursion depth
	})
	return create_new_config_usr // return the formatted response
}

fn new_config(recursion_depth int) UserConfig {
	// generate a new configuration file

	create_new_config_usr := ask_for_new_config(0) // make sure the user wants to generate a new file

	if create_new_config_usr in utils.confirm { // user confirmed
		// start creating the new file
		println("\nCreating new configuration file...")
		return create_configuration() // create the new configuration and return it

	} else if create_new_config_usr in utils.deny { //user denied
		// user requested to not create a new config file, so exit the program.
		println("Cancelling...\nCannot launch without configuration file, exiting program.")
		exit(0) // exit with code 0, because program cannot run without a config
	} else {
		// unexpected input, report to user
		println("\n$create_new_config_usr is an unknown input, please try again.\n")
		utils.recursion_check(recursion_depth, 2) // ensure recursion depth is not too high, if it is then exit with code 2
		return new_config(recursion_depth + 1) // otherwise try again with an increased recursion depth
	}
}