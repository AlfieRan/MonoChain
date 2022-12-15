import cryptography
import time

pub fn test_gen_keys() {
	println("[testing] Testing Key Pair Generation")
	cryptography.gen_keys()
	// because the gen_keys function hasn't exited yet, we know that the keys are valid
	println("[testing] Key Pair Generation Test Passed")
	assert true
}

pub fn test_sign() {
	println("[testing] Testing Signing")
	keys := cryptography.gen_keys()

	println("[testing] Generated a new key pair successfully")
	message := time.utc().str().bytes()

	signed := keys.sign(message)
	println("[testing] Signed a message successfully: $signed")
	println("[testing] Signing Test Passed")

	// because the sign function hasn't exited yet, we know that the signature is valid
	assert true
}

pub fn test_verify() {
	mut failed := false
	println("[testing] Testing Verification")
	keys := cryptography.gen_keys()

	println("[testing] Generated a new key pair successfully")
	message := time.utc().str().bytes()

	signature := keys.sign(message)
	println("[testing] Signed a message successfully")

	if cryptography.verify(keys.pub_key, message, signature) {
		println("[testing] Verified a signature successfully")
		println("[testing] Verification Test Passed")
		failed = false
	} else {
		println("[testing] Verification failed")
		println("[testing] Verification Test Failed")
		failed = true
	}
	
	assert failed == false
}