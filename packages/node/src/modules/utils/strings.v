module utils

pub fn lower(input string) string {
	if input.len == 0 { return "" }

	mut output := ""
	mut i := 0

	for i < input.len {
		mut cur_ltr := input[i]
		if cur_ltr <= 90 && cur_ltr >= 65 {
			cur_ltr = (cur_ltr + 32)
		}

		if cur_ltr != 10 { output = output + cur_ltr.ascii_str() }
		i += 1
	}

	return output
}