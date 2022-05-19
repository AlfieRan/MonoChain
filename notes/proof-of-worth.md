# Proof of Worth

In order to create the proof of worth census that this blockchain will run on we need to first initialise the first Leader node, don't worry I'll explain what a leader node is and how it can be created later but it's important to know that there will need to be an initial leader node and that will need to be hosted by the creator of the blockchain.

* initial leader node is created.
* new nodes send a request to the leader node to be put into the active worker nodes pool.
* These worker nodes are added to the active worker nodes pool, with a predetermined constant "elo" (this represents their trustworthiness ) and because these worker nodes are attached to a wallet in order to receive their payments they can also just store this "elo" in their wallet, **(IMPORTANT - THE FINAL BLOCKCHAIN PROTOCOL MUST NOT ALLOW FOR ELO TO BE TRANSFERRABLE APART FROM DOING SO BY A LEADER NODE).**
* Now that we have a leader node and a pool of active worker nodes with an elo rating we can start putting blocks on the blockchain, to do this a user sends a transaction request to a leader node, and it is piled into the leader node's pending transaction pool.
* Once the transaction pool is large enough that a block can be constructed from it's contents the leader node announces that it has a new block that needs work and publishes all the contents of the block to each worker node.
* Each worker node then starts validating all of the data it has received and then constructs the block using only valid transactions it sends it back to the leader node.
* The leader node then awaits for enough nodes to send back their data so that it has a large enough quantity of the calculated block but not too many so as to prevent the user to have to wait too long for a transaction to go through.
* Now that the leader node has a large quantity of what should theoretically be the same block, it compares all of the worker node's submitted blocks and if over a large majority (90%?) are identical then that will be the final block to be submitted to the blockchain.
* The leader then broadcasts this block to the blockchain and it is added.
