module cryptography

pub fn genKeys() {
	// generate a pair of DSA keys, effectively generating a wallet.
}

pub fn validate_keys(public_key string, private_key string){
	// randomly generate an object, then feed it through sign with the private key to get a signature.
	// then feed this through validate with the original object and the public key to validate it.
	// if valid, then key pair is valid.
	// if invalid, then key pair is invalid.
}