module memory
import os
import json

pub struct Cache_Struct{
	// Since V does not allow for lists to be map keys, all keys must be json encoded then used as a string key
	pub:
		loaded bool
		grudges map[string]i8	// maps a node pub key/id to a local grudge -> negative is good, positive is a bad.
}

pub mut Cache := Cache_Struct{loaded: false}

pub fn load(file_location string){
	if os.exists(file_location) {
		// Trust/Grudge File exists, extract it's contents
		raw := os.read_file(file_location) or {
			eprintln("Failed to read Trust/Grudge file at ${file_location}")
			exit(1)
		}

		data := json.decode(Cache_Struct, raw) or {
			eprintln("Failed to decode Trust/Grudge file at ${file_location}")
			exit(1)
		}

		Cache = data
	}
	// no Trust/grudge file, need to generate a new one
}

pub fn save(file_location string){
	raw := json.encode(Cache)

	os.write_file(file_location, raw) or { // try and write data to file
		// if it failed, run the recursion depth checker to ensure there hasn't been too many failed attempts
		eprintln('Failed to save Trust/Grunge file.')
		exit(1)
	}
}