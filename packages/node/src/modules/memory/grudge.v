module memory 
import json


pub fn (mut Cache Cache_Struct) get_grudge(id []u8) i8 {
	return Cache.alt_grudge(id, 0)
}

pub fn (mut Cache Cache_Struct) inc_grudge(id []u8) i8 {
	return Cache.alt_grudge(id, 1)
}

pub fn (mut Cache Cache_Struct) dec_grudge(id []u8) i8 {
	return Cache.alt_grudge(id, -1)
}

pub fn (mut Cache Cache_Struct) alt_grudge (id []u8, alt i8) i8 {
	if Cache.loaded {
		key := json.encode(id)
		Cache.grudges[key] = (Cache.grudges[key] or { 
			println("Grudge Value for id starting in ${id[0]} not in Cache, setting to zero")
			grudge := i8(0)
			return grudge
		}) + alt

		return Cache.grudges[key]
	} else {
		eprintln("Cache was not loaded properly and therefore cannot be fetched from.")
		exit(1)
	}
}