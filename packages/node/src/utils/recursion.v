module utils

pub fn recursion_check(recursion_depth int, error int){
	if recursion_depth >= 5 {
		// if there are 5 or more errors in a row, exit with error code specified
		eprintln("Failed too many times, exiting.")
		exit(error)
	}
}
