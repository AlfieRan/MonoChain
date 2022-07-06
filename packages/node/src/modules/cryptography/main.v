module cryptography
import crypto.ed25519 as dsa


pub fn gen_keys() (dsa.PublicKey, dsa.PrivateKey) {
	public_key, private_key := dsa.generate_key() or {
		eprintln("Error generating keys")
		exit(150)
	}
	validate_keys(public_key, private_key)

	return public_key, private_key
}

pub fn validate_keys(public_key dsa.PublicKey, private_key dsa.PrivateKey) bool {
	data := "Hello, world!".bytes()
	signature := sign(private_key, data)
	verified := verify(public_key, data, signature)
	if !verified {
		eprintln("Signature verification failed")
		exit(130)
	} else {
		println("Signature verified")
		return true
	}
}

pub fn sign(private_key dsa.PrivateKey, data []u8) []u8 {
	signature := dsa.sign(private_key, data) or {
		eprintln("Error signing data")
		exit(140)
	}
	return signature
}

pub fn verify(public_key dsa.PublicKey, data []u8, signature []u8) bool {
	verified := dsa.verify(public_key, data, signature) or {
		eprintln("Error verifying data")
		exit(145)
	}
	return verified
}	