# Proof of Worth - the bullet point summary.

In order to create the proof of worth census that this blockchain will run on we need to first initialise the first Leader node, don't worry I'll explain what a leader node is and how it can be created later but it's important to know that there will need to be an initial leader node and that will need to be hosted by the creator of the blockchain.

* initial leader node is created.
* new nodes send a request to the leader node to be put into the active worker nodes pool.
* These worker nodes are added to the active worker nodes pool, with a predetermined constant "elo" (this represents their trustworthiness ) and because these worker nodes are attached to a wallet in order to receive their payments they can also just store this "elo" in their wallet,&#x20;
* **(IMPORTANT - THE FINAL BLOCKCHAIN PROTOCOL MUST NOT ALLOW FOR ELO TO BE TRANSFERRABLE APART FROM DOING SO BY A LEADER NODE).**
* Now that we have a leader node and a pool of active worker nodes with an elo rating we can start putting blocks on the blockchain, to do this a user sends a transaction request to a leader node, and first the leader node checks that the amount designated to itself is above the percentage of the final transactions that it wants, then it is piled into the leader node's pending transaction pool.
* Once the transaction pool is large enough that a block can be constructed from it's contents the leader node announces that it has a new block that needs work and publishes all the contents of the block to each worker node.
* Each worker node then starts validating all of the data it has received and then constructs the block using only valid transactions it sends it back to the leader node.
* The leader node then awaits for enough nodes to send back their data so that it has a large enough quantity of the calculated block but not too many so as to prevent the user to have to wait too long for a transaction to go through.
* Now that the leader node has a large quantity of what should theoretically be the same block, it compares all of the worker node's submitted blocks and if over a large majority (90%?) are identical then that will be the final block to be submitted to the blockchain.
* The leader then broadcasts this block to the blockchain and it is added.
* This then completes all of the transactions which were pending and therefore also results in the leader node receiving all of the transaction fees that it required.&#x20;
* Now that the leader node has "the block's mining revenue" it needs to distribute it to it's worker nodes, which it does so by first taking it's own cut (this is up to the leader node's own choice but will be 25% on the initial example node software).
* Then it takes the remaining pile of crypto and distributes it equally to every node that helped construct the block

### Benefits of this system compared to Bitcoin and Ethereum's consensus systems:

#### Bitcoin

Does not waste as much computing power to "mine" a block as a proof of work system such as bitcoin, as it requires an ideal pool of 100-1000 worker nodes per block unlike bitcoin which relies on a pool of millions of nodes for every block.

#### Ethereum

Does not rely on worker nodes being owned by users who already have a large investment in the system unlike a proof of stake model, which in Ethereum's case is a massive hurdle for nodes. `"To participate as a validator, a user must deposit 32 ETH into the deposit contract and run three separate pieces of software: an execution client, a consensus client, and a validator."` [(Wackerow, 2022)](../../reference-list.md) At time of writing 32 ETH is £52657.46 GBP which as absolutely ridiculous hurdle and is the reason why Ethereum only managed to implement this recently which masses of users as opposed to when it was conceived.&#x20;
