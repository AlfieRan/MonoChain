module configuration
import utils

// external imports
import pg

const config_version = 11
pub const base_path = "./monochain"
pub const config_path = "$base_path/config.json"

// Structures and Types
pub struct UserConfig {
	last_connect int	// the last time this node connected to the network
	config_version int
	pub:
		loaded bool	// has the config loaded up
		headless bool	// run in headless mode - no inputs
		key_path string		// the path to the private key file
		self Node	// ref to self
		entrypoint Node = Node{http_ref: "https://nano.monochain.network", ws_ref: "wss://live.monochain.network"}	// the entrypoint node
		db_config DbConfig	// is the db running on a seperate server
		port int	// open port for server - only required if node is public
		ws_port int	// open port for websocket server - only required if node is public
}

type UserConfigType = UserConfig

struct Node {
	pub:
		public bool	// should be true if node has a public ip/dns and false if not
		http_ref string	// only required if node is public
		ws_ref string
		key []u8
}

struct DbConfig {
	pub:
		run_seperate bool // if this is true, the db will run on a seperate server and require below info, if not it will setup using docker
		config pg.Config
}

pub fn get_config() UserConfig {
	// get the user configuration from the defualt file location
	mut user_config := load_config()

	if !user_config.loaded {
		// if config doesn't exist, ask user to create a new one
		println("[config] No config detected, or error occoured.")
		user_config = new_config(0) // start creating a new config with a recursion depth of 0
	}

	if !user_config.loaded {
		// if config failed to load after attempting to create a new one, exit program
		eprintln("[config] Failed to create a new configuration file, unexpected value was $user_config ")
		exit(100) // exit with code 100
	}

	// return config after it's loaded
	println("\n[config] Config Loaded...")
	return user_config
}

fn new_config(recursion_depth int) UserConfig {
	// generate a new configuration file

	println('\n[config] Would you like to create a new configuration file (y/n)?\nWARNING - If you already have a config file this will overwrite it!')
	create_new_config_usr := utils.ask_for_bool(0) // make sure the user wants to generate a new file

	if create_new_config_usr { // user confirmed
		// start creating the new file
		println("\n[config] Creating new configuration file...")
		return create_configuration() // create the new configuration and return it

	} else { //user denied
		// user requested to not create a new config file, so exit the program.
		println("[config] Cancelling...\n[config] Cannot launch without configuration file, exiting program.")
		exit(0) // exit with code 0, because program cannot run without a config
	}
}
