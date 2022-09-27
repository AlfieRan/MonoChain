import utils

fn test_inp_parser() {
	str := "hello"

	// parse the input
	parsed := utils.inp_parser(str)

	assert parsed == str
}

fn test_files() {
	// create a file
	data := "test"
	path := "./test.txt"
	file := utils.save_file(path, data, 0)

	// read the file
	read := utils.read_file(path, true)

	// delete the file
	utils.delete_file(path)

	assert data == read.data
}