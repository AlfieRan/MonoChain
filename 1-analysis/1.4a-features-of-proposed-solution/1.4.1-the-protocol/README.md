# 1.4.1 The Protocol

## 1. Creating Data

This section of the document refers to the creation and requirements of the data that is stored within the transactions and blocks that make up the blockchain on the whole, the discussion of those transactions and blocks is done in[ part 2 of this document, storing data](./#2.-storing-data).

#### Required Fields&#x20;

Whenever new data, whether it be coins, a certificate of ownership, or anything else is created, it is essential that it contains a field that states who created it. This allows anything to be added to the blockchain as if it was a giant public database, but prevents someone from being able to claim they own something that they don't. An example of this is the main currency of this system, the mono, a mono will only be valid and acceptable if its creation flag is attributed to the system. This means that the mono must be created by the system itself, and because typically a creation will be attributed using the creator's public key/id this can only happen when a new block is generated, and such monos should only be accepted as true and valid if when they were created by the system the amount of them created in a single block is below the limit set. How this limit is calculated is described in the below section.

#### How many of a piece of data can be generated.

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



## 2. Storing Data

#### Chaining Blocks

The blocks will need to be chained together in such a way that if a single one of them is edited, all blocks which connect to it prove that it has been mutated and the edited block was not the original block of which they connected to. To do this, the blocks will contain an id field, this id will be the hash of the previous block's and they will also include a parent\_id field, this is the id of that previous block.

This means that the parent\_id can be used to find the parent block of which a child block is chained, then by hashing the parent block and comparing it to the child block's id it can be validated that the pairing has not been tampered with - or if the hash does not equal the child block's id then the pairing has been tampered with and the chain has been invalidated.

The blocks should also contain the number block that they think they are, as this makes validation and navigation easier for nodes, as if a different node supplies them with block 347 in response to a request when the node thinks that there's only 43 blocks in existence then they need to either confirm the larger quantity of blocks or disregard the other node as untrustworthy.

<figure><img src="../../../.gitbook/assets/image (3) (1) (2).png" alt=""><figcaption></figcaption></figure>



## 3. Transferring Data

#### Referencing Owned Data&#x20;

Whenever something happens to a piece of data that requires proof of ownership by a user, such as sending it to someone else, the node calculating whether or not this is valid must travel down the blockchain until it finds enough of that data being sent to the user as the user is attempting to send to someone else. This is to stop users trying to duplicate data because it shows the user actually has the data/items they want to transfer currently in their wallet, but it could result in a node travelling throughout the entire blockchain if a user tries to send an item that they don't own.
