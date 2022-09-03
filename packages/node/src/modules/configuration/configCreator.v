module configuration
import readline { read_line }
import cryptography

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
		ref_path: "$base_path/refs.json"
		loaded: true
		self: Node{
			trust: 0,	// this should be collected from blockchain
			ref: "http://example.com"
			key: cryptography.get_keys(key_path_tmp).pub_key,
		}
		port: 8000
		memory_cache_path: "$base_path/cache.json"
	}

	save_config(config, 0)
	println("A default configuration file has been created at $base_path/config.json\nPlease edit it according to https://monochain.network/download/ \nThen relaunch the program.")
	exit(0)
	return config
}

