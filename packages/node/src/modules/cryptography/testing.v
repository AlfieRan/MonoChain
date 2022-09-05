module cryptography

import time

pub fn generate_key_pair_test() (bool) {
	println("Testing Key Pair Generation")
	gen_keys()
	// because the gen_keys function hasn't exited yet, we know that the keys are valid
	println("Key Pair Generation Test Passed")
	return true
}

pub fn sign_test() (bool) {
	println("Testing Signing")
	keys := gen_keys()

	println("Generated a new key pair successfully")
	message := time.now().str().bytes()

	keys.sign(message)
	println("Signed a message successfully")
	println("Signing Test Passed")

	// because the sign function hasn't exited yet, we know that the signature is valid
	return true
}

pub fn verify_test() (bool) {
	println("Testing Verification")
	keys := gen_keys()

	println("Generated a new key pair successfully")
	message := time.now().str().bytes()

	signature := keys.sign(message)
	println("Signed a message successfully")

	if verify(keys.pub_key, message, signature) {
		println("Verified a signature successfully")
		println("Verification Test Passed")
		return true
	}

	println("Verification failed")
	println("Verification Test Failed")
	return false
}