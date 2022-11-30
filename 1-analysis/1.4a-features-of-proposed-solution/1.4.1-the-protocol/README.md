# 1.4.1 The Protocol

## 1. Creating Data&#x20;

This section of the document refers to the creation and requirements of the data that is stored within the transactions and blocks that make up the blockchain on the whole, the discussion of those transactions and blocks is done in[ part 2 of this document, storing data](./#2.-storing-data).

### Required Fields&#x20;

Whenever new data, whether it be coins, a certificate of ownership, or anything else is created, it is essential that it contains a field that states who created it. This allows anything to be added to the blockchain as if it was a giant public database, but prevents someone from being able to claim they own something that they don't. An example of this is the main currency of this system, the mono, a mono will only be valid and acceptable if its creation flag is attributed to the system. This means that the mono must be created by the system itself, and because typically a creation will be attributed using the creator's public key/id this can only happen when a new block is generated, and such monos should only be accepted as true and valid if when they were created by the system the amount of them created in a single block is below the limit set. How this limit is calculated is described in the below section.

### How many of a piece of data can be generated.

This limit of how many of a data object can be created both per block and in total can be dictated through either a constant value, a function dictated in the protocol, or algorithmically by an algorithm stored in the origin block.&#x20;

Each version has it's own benefits and drawbacks:

{% tabs %}
{% tab title="A Constant Value" %}
| Benefits                                                                                                                                                                 | Drawbacks                                                                                                                                                                  |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Very simple to implement                                                                                                                                                 | Cannot change with pace of block creation, value of item, etc, which could lead to massively devaluing item/data.                                                          |
| Can be set in the protocol to prevent nodes from having to go searching for the data.                                                                                    | Requires an items/data it is regulating to be defined prior to the origin of the blockchain as they must be declared within the protocol (rules of the blockchain) itself. |
| It is very easy to understand how regulation is going to work for a constant - meaning there's virtually no risk of letting an unknown bug ruin user's wallets/finances. | Would require a change to the protocol of the blockchain in order to introduce a new item/data regulator which could lead to a fork of the blockchain.                     |
{% endtab %}

{% tab title="Algorithm defined in the protocol" %}
| Benefits                                                                              | Drawbacks                                                                                                                                                                                   |
| ------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Can be set in the protocol to prevent nodes from having to go searching for the data. | Item/Data being regulated must have been designed prior to/during the creation of the blockchain so that the algorithm can be included in the protocol.                                     |
| Simple to implement                                                                   | Would require a change to the protocol of the blockchain in order to introduce a new item/data regulator which could lead to a fork of the blockchain.                                      |
| Can adapt to the size of the blockchain in the way that a constant value cannot.      | If algorithm is not written correctly, it could cause massive issues for users later on.                                                                                                    |
|                                                                                       | Algorithms are much larger than constants and so could result in an abundance of data just for regulating items/data that doesn't necessarily need to be stored in the protocol definition. |
{% endtab %}

{% tab title="Alogrithm defined in a block" %}
| Benefits                                                                                                                                                                     | Drawbacks                                                                                       |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------- |
| Can be introduced at any point of the blockchain's life span without risking a fork.                                                                                         | Due to not being set in the protocol nodes verifying this data must go and fetch the algorithm. |
| Doesn't needed to be stored in the protocol, meaning reduced complexity.                                                                                                     | More Complicated to implement                                                                   |
| Nodes can fetch and throw away algorithms as needed, meaning they don't have to always store them if they don't use them very often. (unlike a protocol defined regulation.) | If algorithm is not written correctly, it could cause massive issues for users later on.        |
| Can adapt very fluidly to the network's needs as it grows and fluctuates                                                                                                     |                                                                                                 |
{% endtab %}
{% endtabs %}

[(crypto.com, 2022)](../../../reference-list.md)

Due to the above specifications, I will be aiming to add support for algorithms defined in blocks, and initialise the algorithms for base commodities within the origin block, however initially the limits will just be defined as constants as it is much quicker to setup and test with.

This choice also allows for the blockchain to progress into the future without an individual to control it. This is due to the process of voting, which is something the final product would ideally contain, however since that is a feature that requires a lot of pre-requisites I will only be adding it to the project if there is time, although it will be theorised in cycles as they are reached.

| Sender's Public Key | Transactions                  | Recipient's Public Key | Timestamp                     | Sender's Signature |
| ------------------- | ----------------------------- | ---------------------- | ----------------------------- | ------------------ |
| b94d27b9            | \[{type: coin, quantity: 50}] | j45n63m3               | Thu June 17 2022 19:06:50 GMT | 821a643d5ebf18ee9  |

## 2. Storing Data

The data being stored, transferred and owned on the monochain mentioned above will be structured using two fundamental concepts, the block and the transactions that make up the block.

### 2.2 The Transactions

Transactions represent groupings of data being sent from one wallet to another, whether that is the "system wallet" which creates currency or a user sending something they own to another user.

#### The Structure of Transactions and Digital Signatures

Transactions on this blockchain will abide by a few rules, rules which form the system that allow for digital signatures to take place and therefore transactions on the whole.

These rules are the following:

* Wallets (and therefore users) are identified by their public keys
* The transactions themselves are signed using a wallet's private key and then their signature and transaction combo can be verified using that wallet's public key. The point of this is to only allow the sender to create transactions where they send an item, but anyone can check and verify these transactions.
* Transactions should include a timestamp of when they were created by the sender, as the block also contains a timestamp, if the transaction is included on a block that is timestamped to outside of a set time frame then the transaction should be counted as null and void.
* Transactions should then also obviously include where the coins/proof of ownership should be sent to, and what is being sent.

Following these rules gives us an idea of what each transaction should look like:

### 2.1 The Blocks

Blocks are what construct a blockchain, they are groupings of transactions stored with a bunch of meta data that allows them to be chained together in such a way that if any block previous to a specific block is edited, it can be noticed with very few computations so as to ensure the security and confirmation of a set of transactions having actually occoured.&#x20;

#### Storing Blocks

The more blocks a node stores, the better. However they do not need to store them all, as long as nodes know multiple other nodes who store a copy of each block there isn't any major downside to a node only storing a portion of the total blocks in the blockchain.

Yet there is a catch to this, if all nodes begin to only store the most recent blocks then the current existence of the blockchain and all user's wallet contents will be fine and continue as normal but the transaction history for the blockchain will be erased.

This could be looked at as a benefit of the system because it technically increases anonymity whilst retaining function, but in certain cases it could be an issue. The reason this is an accepted risk is because the storage gains and general computational benefits are great enough as a network like this scales and this risk is low enough that it is a worthy risk to take.&#x20;

#### Chaining Blocks

The blocks will need to be chained together in such a way that if a single one of them is edited, all blocks which connect to it prove that it has been mutated and the edited block was not the original block of which they connected to. To do this, the blocks will contain an id field, this id will be the hash of the previous block's and they will also include a parent\_id field, this is the id of that previous block.

This means that the parent\_id can be used to find the parent block of which a child block is chained, then by hashing the parent block and comparing it to the child block's id it can be validated that the pairing has not been tampered with - or if the hash does not equal the child block's id then the pairing has been tampered with and the chain has been invalidated.

The blocks should also contain the number block that they think they are, as this makes validation and navigation easier for nodes, as if a different node supplies them with block 347 in response to a request when the node thinks that there's only 43 blocks in existence then they need to either confirm the larger quantity of blocks or disregard the other node as untrustworthy.

<figure><img src="../../../.gitbook/assets/image (3) (1) (2).png" alt=""><figcaption></figcaption></figure>

#### State Root

This is a concept that has been inspired by Ethereum's feature of the same name and allows the state of all wallets and stores in the blockchain to be tracked simply using a hash of the current state of the entire system in each block. The idea here is that nodes should hold the latest copy of all the contents of every user's wallets, and that a hash of this state root should be stored in every new block such that when a node connects to the network they can get collect the state root from a different node, verify it to the latest block's state root hash and if it is valid, then continue computing from there.

This massively lowers the amount of computations a node has to do per transaction validation, because without this nodes would have to travel back throughout the entire blockchain looking for proof of ownership of an item that is to be transacted.

[(Ethereum, 2015)](../../../reference-list.md)

#### Ensuring Blocks are secure

This is vital to the survival and usefulness of a blockchain, and in the case of the MonoChain will be done in two ways:

1. Identifying blocks using the hashes of their parents to ensure if a block is tampered, all hashes after that block become invalid and the chain is broken.
2. [The Consensus protocol "Proof of Worth"](../2.5.3-consensus-algorithm/2.5.3.1-proof-of-worth-the-bullet-point-summary..md) is used to cut down on the amount of times each node has to validate transactions from each other node.

**The first method**, identifying and chaining the blocks using hashes is detailed in the ["chaining blocks section"](./#chaining-blocks) further up this page.

**The second method**, is a custom designed Consensus Protocol called "Proof of Worth". [(This protocol can be seen in a technical bullet point summary here)](../2.5.3-consensus-algorithm/2.5.3.1-proof-of-worth-the-bullet-point-summary..md). The base concept behind this protocol is to use a trust factor based system that stores, monitors and changes the values of each node's "trustworthiness" within an integer value called that node's "trust". This value can be altered up or down by one unit per each block, with the default node mining software being designed to give a node that helps it a trust increase and a trust decrease to nodes that lie to it.

This then means that as nodes make positive contributions to the blockchain their trust ratings will increase and as bad actors make negative contributions their trust ratings will decrease. Hence when a user wishes to create a transaction, they will be able to choose to send their transaction to a well rated node, which will likely have an increased fee and waiting time, or a worse rated node, which will likely to have a lower fee and waiting time. However this also increases the risk of their transaction not be validated properly and require re-sending.

To learn more about the custom consensus protocol beign hypothesised, I have created a bullet point summary of the theory of how it would work in the file ["Proof of Worth - the bullet point summary."](../2.5.3-consensus-algorithm/2.5.3.1-proof-of-worth-the-bullet-point-summary..md)

##

## 4. Transferring Data

#### Referencing Owned Data&#x20;

Whenever something happens to a piece of data that requires proof of ownership by a user, such as sending it to someone else, the node calculating whether or not this is valid must travel down the blockchain until it finds enough of that data being sent to the user as the user is attempting to send to someone else. This is to stop users trying to duplicate data because it shows the user actually has the data/items they want to transfer currently in their wallet, but it could result in a node travelling throughout the entire blockchain if a user tries to send an item that they don't own.
