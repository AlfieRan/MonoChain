# 1.4 Features of Proposed Solution

## The solution will contain three main parts.

Due to how large this file became whilst working on it I have split the solution up into seperate files for each section so as to make it easier to navigate and read this part of the project.

### [The Protocol](1.4.1-the-protocol/)

This is what describes how the blockchain will operate, how it is put together and how [nodes](../../terminology.md#nodes) will operate. It is what will be described throughout the rest of this section.

### [The Node Software](1.4.2-the-node-software.md)

This is the software that runs on a computer contributing to the network and uses the rules created in the protocol to generate, validate and view blocks and transactions within the blockchain. Since this is effectively the software form of the protocol it will not be described in this section.

### [The Web-portal](1.4.3-the-webportal.md)

This simply acts as an introduction to the project and will host some key information, a link to the documents of this project of which you are currently reading, a link to view the source code for the entire project and hopefully some other features which I will mention at the end of this section.



## Limitations

### Performance

Although I would like to make it so that any person with a spare computer could help compute towards this blockchain as a node and receive as much of a reward as someone with a top of the line server, due to the nature of this project being computationally complex, the more powerful a computer is, the more useful it is to the system.

This is because nodes need to not only do thousands of checks, data requests, node-to-node communications and general computations per block validation, but they need to be able to do so fast enough to be a part of the validation of a block that makes it on to the blockchain in order to actually receive a reward.

Therefore the blockchain system itself will be limited by the capabilities of its nodes and the nodes will be limited by the relative performance of themselves to the other nodes on the network.
