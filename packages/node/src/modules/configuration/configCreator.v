module configuration
import readline { read_line }
import cryptography

const key_path_const = "$base_path/keys.config"

pub fn create_configuration(inp_path StrBool) UserConfig {
	config := UserConfig{
		config_version: config_version
		key_path: key_path_const
		loaded: true
		self: Node{
			http_ref: "http://example.com"
			ws_ref: "ws://example.com"
			key: cryptography.get_keys(key_path_const).pub_key,
		}
		ports: Ports{
			http: 8000
			ws: 8001
		}
	}

	save_config(config, 0, inp_path)
	println("[config] A default configuration file has been created at $base_path/config.json\nPlease edit it according to https://monochain.network/download/ \nThen relaunch the program.")
	return config
}

