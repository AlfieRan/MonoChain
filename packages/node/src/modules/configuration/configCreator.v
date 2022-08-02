module configuration
import readline { read_line }
import cryptography
import crypto.ed25519 as dsa
import utils

const defualt = UserConfig{
	loaded: true
	config_version: config_version
	last_connect: 0
	port: 8000

}

pub fn create_configuration() UserConfig {
	config := UserConfig{
		last_connect: 0
		config_version: config_version
		key_path: "$base_path/keys.config"
		loaded: true
		self: Node{
			trust: 0,	// this should be collected from blockchain
			ref: "self"
			key: pub_key
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

fn ask_for_keys_inp(recursion_depth int) string {
	eprintln("Input failed, please try again")
	utils.recursion_check(recursion_depth, 4)
	return ask_for_keys_inp(recursion_depth + 1)
}

fn ask_for_keys(recursion_depth int) (dsa.PublicKey, dsa.PrivateKey) {
	println("Please enter your public key:")
	pub_key := utils.inp_parser(read_line("$:\t") or {ask_for_keys_inp(recursion_depth)}).bytes()
	println("Please enter your private key:")
	priv_key := utils.inp_parser(read_line("$:\t") or {ask_for_keys_inp(recursion_depth)}).bytes()
	return pub_key, priv_key
}

fn get_keys(recursion_depth int) (dsa.PublicKey, dsa.PrivateKey) {
	println("Would you like to generate a new keypair? (y/n)")
	gen_keys := utils.ask_for_bool(0)

	if gen_keys {
		return cryptography.gen_keys()
	} else {
		println("Do you have a keypair already? (y/n)")
		have_keys := utils.ask_for_bool(0)
		if have_keys {
			return ask_for_keys(0)
		} else {
			eprintln("Cannot continue without a keypair!")
			exit(75)
		}
	}
}
