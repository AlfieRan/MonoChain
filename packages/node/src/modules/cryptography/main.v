module cryptography	// this module
import crypto.ed25519 as dsa	// an external module used to handle all the dsa stuff - too complicated for the time scope of this project.

pub struct Keys {
	priv_key dsa.PrivateKey
	pub: 
		pub_key dsa.PublicKey
}

type KeysType = Keys

pub fn (this Keys) validate_keys() bool {
	data := "Hello, world!".bytes()		// defines some random data to check a key pair with
	signature := this.sign(data)	// signs that data using tthe private key
	verified := verify(this.pub_key, data, signature)		// validate that data with that signature and key pair
	if verified == false {	// if verification failed
		eprintln("Signature verification failed")
		exit(130)	// exit with error code 130
	} else {	// verification succeeded
		println("Signature verified")
		return true	// valid so return true
	}
}

pub fn (this Keys) sign(data []u8) []u8 {
	// wrap the sign function to prevent having conditional data throughout program.
	signature := dsa.sign(this.priv_key, data) or {
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