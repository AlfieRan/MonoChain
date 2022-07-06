module utils
import readline { read_line }

pub fn inp_parser(input string) string {
	lower := input.to_lower()
	mut output := ""
	mut i := 0

	for (i < lower.len){
		if lower[i] >= alphabet_lower && lower[i] <= alphabet_upper {
			output = output + lower[i].ascii_str()
		}
		i++
	}

	return output
}

pub fn ask_for_bool(recursion_depth int) bool {
	mut response := inp_parser(read_line("$:") or { 
		eprintln("Input failed, please try again")
		utils.recursion_check(recursion_depth, 3)
		return ask_for_bool(recursion_depth + 1)
	})

	if response in utils.confirm {
		return true
	} else if response in utils.deny {
		return false
	} else {
		eprintln("That is not a valid input, please try again")
		utils.recursion_check(recursion_depth, 5)
		return ask_for_bool(recursion_depth + 1)
	}
}
