module configuration
import json
import utils

pub fn load_config(inp_path StrBool) UserConfig {
	mut path := config_path

	if inp_path is string {
		path = inp_path
	}

	raw := utils.read_file(path, true)

	if !raw.loaded{
		return UserConfig{loaded: false}
	} 

	user_config := json.decode(UserConfig, raw.data) or {
		return UserConfig{loaded: false}
	}

	if user_config.config_version != config_version {
		println("[config] Your Configuration file is outdated, would you like to regenerate it?\nWARNING - If you don't some features may not work properly and may even crash the program.") 
		if utils.ask_for_bool(0){
			create_configuration(false)
			exit(0)
		}
	}

	return user_config // config loaded and no issues with it
} 

type StrBool = string | bool

pub fn save_config(config UserConfig, recursion_depth int, inp_path StrBool) bool {
	mut path := config_path

	if inp_path is string {
		path = inp_path
	}

	data := json.encode(config) // encode the current configuration to json
	failed := utils.save_file(path, data, 0) // save the json to the file

	if !failed {
		println("[config] Sucessfully saved configuration file.") 
	} else {
		println("[config] Failed to save configuration file.\nCannot run without a configuration file.") 
		exit(215)
	}
	return failed
}