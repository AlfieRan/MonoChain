module utils
import os

pub fn read_file<T>(path string, encoding T, bypass_crash ?bool) (T | false) {
	if os.exists(path) {
		raw := os.read_file(path) or {
			// something went wrong opening the file, return without loading the config
			eprintln('Failed to open the file at path $path, error $err')
			if bypass_crash {return false}
			else {exit(200, 'Failed to open the file at path $path, error $err')}
		}

		output := json.decode(T, raw) or {
			// something went wrong decoding the file, return without loading the config
			eprintln('Failed to decode json of file $path, error: $err')
			if bypass_crash {return false}
			else {exit(210, 'Failed to open the file at path $path, error $err')}
		}

		return output
	} else {
		eprintln("File $path does not exist")
		if bypass_crash {return false}
		else {exit(205, 'File $path does not exist')}
	}
}

pub fn save_file(path string, data string, recursion_depth int) (bool) {
	mut failed:= false

	os.write_file(path, data) or { // try and write data to file
		// if it failed, run the recursion depth checker to ensure there hasn't been too many failed attempts
		eprintln('Failed to save file, trying again.')
		if recursion_depth >= 5{
			eprintln("Failed to save file too many times, continuing with program but your file at $path won't be saved")
			failed = true
		} else {
			failed = !save_file(path, path, recursion_depth + 1)
		}
	}

	return failed
}