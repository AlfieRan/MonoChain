module memory

// internal imports
import utils
// external imports
import json

struct InternalRef {
	mut:
		keys map[string][]u8	// this maps a reference the pub key that it runs using.
		blacklist map[string]bool	// this is a list of pub keys that we've already seen and do not trust. Erased when the node is restarted.
}

pub struct References {
	path string
	mut:
		http InternalRef
		ws InternalRef
}

// need to figure out a way of making the references object global so that it can just be kept in memory

fn (Ref References) save() {
	// create a new object to ignore blacklisted keys
	raw := json.encode(References{
		path: Ref.path
		http: InternalRef{
			keys: Ref.http.keys
		}
		ws: InternalRef{
			keys: Ref.ws.keys
		}
	})

	println("[References] Saving references as $raw")
	utils.save_file(Ref.path, raw, 0)
}

fn new(file_path string) References {
	println("[references] Generating a new reference object")
	ref := References{
		path: file_path
		http: InternalRef{
			keys: map[string][]u8{},
			blacklist: map[string]bool{},
		}
		ws: InternalRef{
			keys: map[string][]u8{},
			blacklist: map[string]bool{},
		}
		
	}
	ref.save()
	return ref
}

pub fn get_refs(file_path string) References {
	raw := utils.read_file(file_path, true)
	mut refs := References{}	// incase no file or error

	if raw.loaded != false {
		println("[References] Loading Reference from file")
		// convert the json data to a References struct.
		refs = json.decode(References, raw.data) or {
			println("[References] Failed to load references, error: $err")
			// if the json is invalid, create a new one.
			new(file_path)
		}
	} else {
		println("[References] Couldn't find a reference file, therefore creating a new one")
		refs = new(file_path)
	}

	return refs
}

type UpdateInfo = string | bool

fn (mut Ref References) update(path UpdateInfo) {
	// create a new object to ignore blacklisted keys
	mut use_path := Ref.path

	if path is string {
		use_path = path
	}

	new := get_refs(use_path)
	if new != Ref {
		Ref = new
	}
}

pub fn (refs References) aware_of(reference string) bool {
	// check if the reference is in the blacklist.
	if refs.ws.blacklist[reference] || refs.http.blacklist[reference] {
		// we have encountered this reference before and it is blacklisted.
		return true
	}

	// if it is not blacklisted, check if the reference is in the keys.
	if reference in refs.ws.keys || reference in refs.http.keys {
		// we have encountered this reference before and it is not blacklisted.
		return true
	}

	// we have not encountered this reference before.
	return false
}

pub fn (mut refs References) add_key_http(reference string, key []u8) {
	// add the key to the keys map.
	
	refs.http.keys[reference] = key
	// save the references.
	println("[References] Adding http reference as $reference, then saving references")
	refs.save()
}

pub fn (mut refs References) add_blacklist_http(reference string) {
	// add the reference to the blacklist.
	refs.http.blacklist[reference] = true
	// save the references.
	println("[References] Adding http blacklist as $reference, then saving references")
	refs.save()
}

pub fn (mut refs References) add_key_ws(reference string, key []u8) {
	// add the key to the keys map.
	println("[References] Adding ws reference as $reference")
	refs.ws.keys[reference] = key
	// save the references.
	refs.save()
}

pub fn (mut refs References) add_blacklist_ws(reference string) {
	// add the reference to the blacklist.
	println("[References] Adding ws blacklist as $reference")
	refs.ws.blacklist[reference] = true
	// save the references.
	refs.save()
}
