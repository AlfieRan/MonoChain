module utils

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
