# Phase 1

Phase 1 will be a very basic version of the final blockchain, featuring a centralised node basis, something that will obviously be changed in a future phase, such that basic JSON transactions can be made by a user by sending a request to a set, centralised node.

Features required to run phase 1:

* A Transaction schema, which represents how transactions will be formed.
* A Blockchain Schema, which is effectively just a block schema and a method for chaining the blocks together.
* A temporary node script to receive transactions from a client and apply them to the blockchain.
* The ability to store the blockchain in a json file so that the node can be closed and reopened without losing all it's data.

### Transactions and Digital Signatures - Schema

Transactions on this blockchain will abide by a few rules, rules which form the system that allow for digital signatures to take place and therefore transactions on the whole.

These rules are the following:

* Wallets (and therefore users) are identified by their public keys
* The transactions themselves are encrypted using a wallet's private key and can be decrypted using that wallet's public key. This is effectively the opposite of standard encryption, as anyone can read this data, because only the owner can write a transaction involving themselves, however with typical encryption, anyone can write a message but only the owner can read them.
* Transactions should include a timestamp of when they were approved, if the transaction is included on a block that is timestamped to outside of a set time frame of the transaction's time stamp then the transaction should be counted as null and void.
* Transactions should then also obviously include where the coins/proof of ownership should be sent to, and what is being sent.

Following these rules gives us an idea of what each transaction should look like:

| Sender's public key | Transaction                | Recipient's public key | Timestamp                    | Sender Encrypted Copy |
| ------------------- | -------------------------- | ---------------------- | ---------------------------- | --------------------- |
| b94d27b9            | {type: coin, quantity: 50} | j45n63m3               | Thu Mar 17 2022 19:06:50 GMT | 821a643d5ebf18ee9     |

In JSON format that would look something like the following: (Although bear in mind that the keys and encrypted version are completely made up and aren't accurate.)

```
{
    Sender-Key: "b94d27b9",
    Transaction:
        [{type: coin, quantity: 50}],
    Recipient-Key: "j45n63m3",
    Timestamp: "Thu Mar 17 2022 19:06:50 GMT",
    Sender-Encrypted: "821a643d5ebf18ee9"
}
```

## The schema of a Block and how they will be connected

One issue with most blockchain technologies is that they must abide by a time limit. Meaning that the amount of transactions is limited, which is not good.

One example of this is the blockchain for bitcoin, which requires a new block to be registered approximately once per ten minutes (it accomplishes this by varying the difficulty of mining a block) and the amount of transactions is hard capped at 1MB, which caps the amount of transactions to approximately 3000 per block. Because of this the average amount of transactions sent over the bitcoin blockchain is approximately 4.6 per second, [(Anonymous, 2022)](../reference-list.md) which is significantly lower than Visa's 1700 transactions per second (reference visa).&#x20;

So how does visa sustain 350 times as many transactions per second as bitcoin? The simple reason is that visa does not use a block based model, instead it just sends transactions separately and as needed, this removes any bottlenecking created by miner nodes waiting for the next block request and only being able to fit a certain amount of transactions in each block.&#x20;

That seems like the obvious solution right? Just send all the transactions separately, with one per block? No, that would not work at all, because all blocks have to be "chained" to the block before, you would not only have lots of blocks all chained to the same block but it would be very very difficult to determine if a block was legitimate or not because of the pure mass of data flowing through at any given time making it much easier for a fraudulent block to slip through.

So we want the maximum amount of transactions per block to be high enough that there should always be some space in the amount of left over transactions but not too high so that the amount of left over, empty transactions, are kept at a minimum. Alongside this we need to ensure that blocks occur frequently enough that transactions do not take too long to occur and are not stacked up into unreasonably massive blocks, yet keep the blocks infrequent enough so that they do not become too easy to mine and therefore increase the probability of a fraudulent block successfully defrauding the system.

### **Ensuring that Blocks occur at the correct rate**

To calculate how often we want blocks to be created on the blockchain
