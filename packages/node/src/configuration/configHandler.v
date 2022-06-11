module configuration
import readline { read_line }
import utils

struct UserConfig {
	pub: 
		loaded bool
		port int
}

pub fn get_config() UserConfig {
	mut user_config := load_config()

	if !user_config.loaded {
		println("No config detected, or error occoured.")
		user_config = new_config(0)
	}

	if !user_config.loaded {
		eprintln("Failed to create a new configuration file, unexpected value was $user_config ")
		exit(100)
	}

	println("\nConfig Loaded, launching API server...")
	return user_config
}

fn ask_for_new_config(recursion_depth int) string {
	create_new_config_usr := utils.lower(read_line('\nWould you like to create a new configuration file (y/n)?\nWARNING - If you already have a config file this will overwrite it!\n$:') or {
		eprintln("Input failed, error $err")
		utils.recursion_check(recursion_depth, 50)

		return ask_for_new_config(recursion_depth + 1) // otherwise try again with an increased recursion depth
	})
	return create_new_config_usr
}

fn new_config(recursion_depth int) UserConfig {
	create_new_config_usr := ask_for_new_config(0)

	if create_new_config_usr in utils.confirm {
		// start creating the new file
		println("\nCreating new configuration file...")
		return create_configuration()

	} else if create_new_config_usr in utils.deny {
		// user requested to not create a new config file, so exit the program.
		println("Cancelling...\nCannot launch without configuration file, exiting program.")
		exit(0)
	} else {
		// unexpected input, report to user
		println("\n$create_new_config_usr is an unknown input, please try again.\n")
		utils.recursion_check(recursion_depth, 2)
		return new_config(recursion_depth + 1)
	}
}