module cryptography	// this module
import crypto.ed25519 as dsa	// an external module used to handle all the dsa stuff - too complicated for the time scope of this project.


pub fn gen_keys() (dsa.PublicKey, dsa.PrivateKey) {
	// This is just a wrapper function to prevent the rest of the code having to deal with keys being incorrectly generated
	// throughout the rest of the program

	public_key, private_key := dsa.generate_key() or {
		eprintln("Error generating keys")
		exit(150)
	}
	validate_keys(public_key, private_key)

	return public_key, private_key
}

pub fn validate_keys(public_key dsa.PublicKey, private_key dsa.PrivateKey) bool {
	data := "Hello, world!".bytes()		// defines some random data to check a key pair with
	signature := sign(private_key, data)	// signs that data using tthe private key
	verified := verify(public_key, data, signature)		// validate that data with that signature and key pair
	if !verified {	// if verification failed
		eprintln("Signature verification failed")
		exit(130)	// exit with error code 130
	} else {	// verification succeeded
		println("Signature verified")
		return true	// valid so return true
	}
}

pub fn sign(private_key dsa.PrivateKey, data []u8) []u8 {
	// wrap the sign function to prevent having conditional data throughout program.
	signature := dsa.sign(private_key, data) or {
		eprintln("Error signing data")
		exit(140)
	}
	return signature
}

pub fn verify(public_key dsa.PublicKey, data []u8, signature []u8) bool {
	// wrap verify function to prevent having conditional data throughout program.
	verified := dsa.verify(public_key, data, signature) or {
		eprintln("Error verifying data")
		return false
	}
	return verified
}	