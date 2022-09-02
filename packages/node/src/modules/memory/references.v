module memory

// internal imports
import utils
// external imports
import json


// This is a simple way of storing the nodes memory of other nodes that it's encountered.

pub struct References {
	path string
	mut:
		keys map[string][]u8	// this maps a reference the pub key that it runs using.
		blacklist map[string]bool	// this is a list of pub keys that we've already seen and do not trust. Erased when the node is restarted.
}

fn (Ref References) save() {
	// create a new object to ignore blacklisted keys
	raw := json.encode(References{
		path: Ref.path
		keys: Ref.keys
	})
	utils.save_file(Ref.path, raw, 0)
}

fn new(file_path string) References {
	ref := References{
		path: file_path
		keys: map[string][]u8{},
		blacklist: map[string]bool{},
	}
	ref.save()
	return ref
}

pub fn get_refs(file_path string) References {
	raw := utils.read_file(file_path, true)
	mut refs := new(file_path)	// incase no file or error

	if raw.loaded != false {
		// convert the json data to a References struct.
		refs = json.decode(References, raw.data) or {
			// if the json is invalid, create a new one.
			new(file_path)
		}
	}

	return refs
}

pub fn (refs References) aware_of(reference string) bool {
	// check if the reference is in the blacklist.
	if refs.blacklist[reference] {
		// we have encountered this reference before and it is blacklisted.
		return true
	}

	// if it is not blacklisted, check if the reference is in the keys.
	if reference in refs.keys {
		// we have encountered this reference before and it is not blacklisted.
		return true
	}

	// we have not encountered this reference before.
	return false
}

pub fn (mut refs References) add_key(reference string, key []u8) {
	// add the key to the keys map.
	refs.keys[reference] = key
	// save the references.
	refs.save()
}

pub fn (mut refs References) add_blacklist(reference string) {
	// add the reference to the blacklist.
	refs.blacklist[reference] = true
	// save the references.
	refs.save()
}