module cryptography
import utils

pub fn get_keys(key_path string) (Keys) {
	mut keys := utils.read_file(key_path, Keys, true)
	
	if keys == false {
		println("Could not load keys from file, would you like to generate a new pair?")
		if utils.get_yes_no() {
			keys = gen_keys()
			utils.save_file(key_path, keys)
			return keys
		} else {
			eprintln("Cannot operate without a keypair, Exiting...")
			exit(1)
		}
	} else if keys != false {
		println("Keys loaded from file.")
		return keys
	}
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