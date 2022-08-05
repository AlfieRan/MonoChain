module utils
import os

struct FileReading {
	pub:
		loaded bool [required]
		data string
}

pub fn read_file(path string, bypass_crash bool) (FileReading) {
	println("Reading file: " + path)
	if os.exists(path) {
		raw := os.read_file(path) or {
			// something went wrong opening the file, return without loading the config
			eprintln('Failed to open the file at path $path, error $err')

			if bypass_crash {
				return FileReading{loaded: false}
			}

			exit(200)
		}

		return FileReading{loaded: true, data: raw}
	} else {
		eprintln("File $path does not exist")
		if bypass_crash {return FileReading{loaded: false}}
		else {exit(205)}
	}
}

pub fn save_file(path string, data string, recursion_depth int) (bool) {
	mut failed:= false

	if !os.exists(path) {
		os.create(path) or {
			eprintln('Failed to create the file at path $path, error $err')
			return true
		}
	}

	os.write_file(path, data) or { // try and write data to file
		// if it failed, run the recursion depth checker to ensure there hasn't been too many failed attempts
		eprintln('Failed to save file, error ${err}\nTrying again.')
		if recursion_depth >= 5{
			eprintln("Failed to save file too many times, continuing with program but your file at $path won't be saved")
			failed = true
		} else {
			failed = !save_file(path, path, recursion_depth + 1)
		}
	}

	return failed
}