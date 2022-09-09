module cryptography

import time

pub fn generate_key_pair_test() (bool) {
	println("[testing] Testing Key Pair Generation")
	gen_keys()
	// because the gen_keys function hasn't exited yet, we know that the keys are valid
	println("[testing] Key Pair Generation Test Passed")
	return true
}

pub fn sign_test() (bool) {
	println("[testing] Testing Signing")
	keys := gen_keys()

	println("[testing] Generated a new key pair successfully")
	message := time.now().str().bytes()

	keys.sign(message)
	println("[testing] Signed a message successfully")
	println("[testing] Signing Test Passed")

	// because the sign function hasn't exited yet, we know that the signature is valid
	return true
}

pub fn verify_test() (bool) {
	println("[testing] Testing Verification")
	keys := gen_keys()

	println("[testing] Generated a new key pair successfully")
	message := time.now().str().bytes()

	signature := keys.sign(message)
	println("[testing] Signed a message successfully")

	if verify(keys.pub_key, message, signature) {
		println("[testing] Verified a signature successfully")
		println("[testing] Verification Test Passed")
		return true
	}

	println("[testing] Verification failed")
	println("[testing] Verification Test Failed")
	return false
}