module cryptography
import utils
import crypto.ed25519 as dsa
import json

pub fn get_keys(key_path string) (Keys) {
	keys := utils.read_file(key_path, Keys{}, true)
	
	if !keys.loaded {
		println("Could not load keys from file, would you like to generate a new pair?")
		if utils.ask_for_bool(0) {
			new_keys := gen_keys()
			utils.save_file(key_path, json.encode(new_keys), 0)
			return new_keys
		} else {
			eprintln("Cannot operate without a keypair, Exiting...")
			exit(1)
		}
	}

	println("Keys loaded from file.")
	return keys.data
}

pub fn gen_keys() (Keys) {
	// This is just a wrapper function to prevent the rest of the code having to deal with keys being incorrectly generated
	// throughout the rest of the program

	public_key, private_key := dsa.generate_key() or {
		eprintln("Error generating keys")
		exit(150)
	}
	keys := Keys{
		pub_key: public_key,
		priv_key: private_key,
	}

	keys.validate_keys()

	return keys
}