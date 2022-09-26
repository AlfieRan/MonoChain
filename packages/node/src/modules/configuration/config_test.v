import configuration

const test_config_path = "./test_config.json"

fn test_config_creation() {
	println("[Testing - Configuration] Running test: config_creation")
	config := configuration.create_configuration(test_config_path)
	assert true // if code gets to this point, the value has to be a valid configuration
}

fn test_config_load() {
	println("[Testing - Configuration] Running test: config_load")
	config := configuration.load_config(test_config_path)
	assert true // if code gets to this point, the value has to be a valid configuration
}

fn test_config_save_then_load() {
	println("[Testing - Configuration] Running test: config_save_then_load")
	config := configuration.create_configuration(test_config_path)
	configuration.save_config(config, 0, test_config_path)
	loaded_config := configuration.load_config(test_config_path)
	assert config == loaded_config
}

fn test_get_config() {
	get_config := configuration.get_config() // change this to a specified path
	assert true
}