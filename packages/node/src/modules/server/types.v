module server

pub interface Node_Type {
	wallet string 	// the wallet public key (id)
	mut:
		trust int 	// Node's current trust level
		route string	// ip or domain to connect
		grudge int	// personal rating: positive = good, negative = bad
}

pub interface Blockchain_State {
	headers State_Tree_Headers 	// standard headers for block verification - verify to child trees
	domains Domain_Tree 		// domains refer to wallets on the blockchain without having to use a boring wallet key
	wallets Wallet_Tree			// This stores all the contents of all the wallets currently on the blockchain
}

interface State_Tree_Headers {
	last_updated int // time since Epoch
	block_id int // last block updated
}

pub interface Domain_Tree {
	headers State_Tree_Headers // standard headers for block verification - verify to parent tree
	domains map[string]string // maps a custom blockchain domain to a wallet pub key
}

pub interface Wallet_Tree {
	headers State_Tree_Headers	// standard headers for block verification - verify to parent tree
	wallets map[string]Wallet	// maps a wallet pub key/id to a wallet object
}

pub interface Wallet {
	wallet string // this wallet's pub key/id
	// a bunch of other stuff I haven't figured out how to structure this yet
}
