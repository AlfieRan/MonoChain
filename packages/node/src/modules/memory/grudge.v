module memory 
import json


pub fn get_Grudge(id []u8) i8 {
	return alt_Grudge(id, 0)
}

pub fn inc_Grudge(id []u8) i8 {
	return alt_Grudge(id, 1)
}

pub fn dec_Grudge(id []u8) i8 {
	return alt_Grudge(id, -1)
}

pub fn alt_Grudge (id []u8, alt i8) i8 {
	if Cache.loaded {
		key := json.encode(id)

		return Cache.grudges[key] = (Cache.grudges[key] or { 
			println("Grudge Value for id starting in ${id[0]} not in Cache, setting to zero")
			grudge := 0
			Cache.grudges[key] = grudge
			return grudge
		}) + alt
	} else {
		eprintln("Cache was not loaded properly and therefore cannot be fetched from.")
		exit(1)
	}
}