# Proof of Worth

In order to create the proof of worth census that this blockchain will run on we need to first initialise the first Leader node, don't worry I'll explain what a leader node is and how it can be created later but it's important to know that there will need to be an initial leader node and that will need to be hosted by the creator of the blockchain.

* initial leader node is created.
* new nodes send a request to the leader node to be put into the active nodes pool.
* These nodes are added to the active nodes pool, with a predetermined constant "elo" (this represents their trustworthiness ) and because these nodes are attached to a wallet in order to receive their payments they can also just store this "elo" in their wallet, **(IMPORTANT - THE FINAL BLOCKCHAIN PROTOCOL MUST NOT ALLOW FOR ELO TO BE TRANSFERRABLE APART FROM DOING SO BY A LEADER NODE).**
* Now that we have a leader node and a pool of active nodes with an elo rating we can start putting blocks on the blockchain
