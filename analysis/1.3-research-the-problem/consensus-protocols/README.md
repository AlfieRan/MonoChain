---
description: >-
  A brief description of what a consensus protocol is and any protocols I
  mentioned in this project that do not have explanations in other documents.
---

# Consensus Protocols

### What is a Consensus Protocol?

A consensus protocol is the protocol that a blockchain system uses to validate blocks created by nodes during the block creation stage. This is needed because in a decentralised system, the nodes (aka computers) that run the system cannot necessarily be trusted, as one node may wish to do something that benefits themselves such as paying themselves currency that doesn't actually exist. This type of node is typically referred to as a bad actor

### Proof of Work

Proof of work is the most common consensus protocol and was originally introduced by the bitcoin blockchain, it is quite simple and secure which is what made it a good choice for the first cryptocurrency, however it does also have some serious issues.

It works by requiring the hash of a block that is added to the blockchain to be below a target value based upon how long it took the past&#x20;

explanation for proof of power goes here [(How Bitcoin makes it harder to mine dynamically)](how-bitcoin-makes-mining-harder..md)

| Benefits                                                              | Drawbacks                                                                                                                                                                                                                                                                                                                          |
| --------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| If miners are grouped into pacts the entry cost can be relatively low | Miners acting alone are extremely unlikely to be the node who successfully mines a block and can therefore spend lots of money on power/energy to receive no revenue.                                                                                                                                                              |
| Simple and hard to bypass                                             | Costs a ridiculous amount of cumulative energy from all the mining nodes to mine each block - which is very bad for the environment.                                                                                                                                                                                               |
| Scales with increases in computing power extremely well               | If a large entity with lots of computing power wanted to they could theoretically create a node network at least 51% of the size of the whole network, centralising it and having complete control of all the data flowing through the network.                                                                                    |
|                                                                       | Nodes with extremely large computing power do not have to group up and can therefore reap all the rewards of their work alone, growing faster and resulting in a big divide between the ultra wealthy and powerful single nodes and the less wealthy, not very powerful grouped nodes that can't accomplish anything on their own. |

Lots of the drawbacks were sourced from [(Wackerow, 2022)](../../../reference-list.md).

### Proof of Stake

Proof of stake is a consensus protocol that relies upon nodes/miners \*staking\* capital which usually comes in the form of the native currency for a specified blockchain, such that the staked capital can act as a form of deposit. This stake/deposit can then be destroyed if the node/miner becomes dishonest or lazy, where being lazy tends to mean only validating their own blocks and no-one else's.

| Benefits                                           | Drawbacks                                                                                                  |
| -------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| better energy efficiency compared to proof of work | usually very high stake requirements, requiring a much larger initial investment compared to proof of work |
| lower hardware entry requirements                  | more complex than proof of work                                                                            |
| should increase security                           |                                                                                                            |
