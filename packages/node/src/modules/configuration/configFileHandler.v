module configuration
import json
import utils

pub fn load_config() UserConfig {
	raw := utils.read_file(config_path, true)

	if !raw.loaded{
		return UserConfig{loaded: false}
	} 

	user_config := json.decode(UserConfig, raw.data) or {
		return UserConfig{loaded: false}
	}

	if user_config.config_version != config_version {
		println("Your Configuration file is outdated, would you like to regenerate it?\nWARNING - If you don't some features may not work properly and may even crash the program.") 
		if utils.ask_for_bool(0){
			return create_configuration()
		}
	}

	return user_config // config loaded and no issues with it
} 

pub fn save_config(config UserConfig, recursion_depth int) bool {
	data := json.encode(config) // encode the current configuration to json
	failed := utils.save_file(config_path, data, 0) // save the json to the file

	if !failed {
		println("Sucessfully saved configuration file.") 
	} else {
		println("Failed to save configuration file.\nCannot run without a configuration file.") 
		exit(215)
	}
	return !failed
}