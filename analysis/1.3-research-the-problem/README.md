# 1.3 Research

## Bitcoin

![](../../.gitbook/assets/image.png)

![](<../../.gitbook/assets/image (1).png>)

### Overview

Bitcoin was created in 2008 and was the first cryptocurrency to be created digitally, it has also gone on to become the most valuable cryptocurrency per coin, being valued at £24,082.50 GBP per coin as of the 18th of May 2022, being over 10 times the value of the next most valuable per coin cryptocurrency, Eth on the Ethereum blockchain (which I have also researched below) of which is valued at £1,638.47 GBP. Although it is worth mentioning that there are approximately 120 million Eth in circulation at the point of writing, compared to Bitcoin's 18 million, which closes the total valuation gap considerably.



### [Consensus Protocol](consensus-protocols/#what-is-a-consensus-protocol)

Bitcoin uses [proof of power](consensus-protocols/#proof-of-power) as it's [Consensus Protocol](consensus-protocols/#what-is-a-consensus-protocol), the benefit of this is that in order to deceive the blockchain protocol and successfully defraud the system, an individual would need 51% of the computing power connected to the network, which is feasible initially but as the network grows becomes extremely difficult to do so, especially at it's current state. The downside to using proof of power is that it it is extremely inefficient and wastes a lot of energy [(for an explanation why click here)](consensus-protocols/#proof-of-power). This is not only bad for the environment but also raises transaction fees as nodes have to do a lot more work to complete each transaction and have to be compensated fairly.

![Bitcoin's USD transaction cost over time](<../../.gitbook/assets/image (3).png>)

The above chart shows this transaction fee over time, and although right now it is pretty reasonable at approx $2 per transaction (£1.59) it is not always stable can get quite high, such as during July 2020 to July 2021 where transaction fees rose to averaging around $10 and peaking at $62 per transaction, an amount that makes any small transaction pointless.

### Features

{% tabs %}
{% tab title="Features I will Include" %}
| Feature                             | Justification                                                                                                                                                   |
| ----------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| A base cryptocurrency               | This is what the majority of systems involved will use as their currency and acts a central protocol, it will also likely be what transaction fees are paid in. |
| Cryptographically safe transactions | This is what allows nodes to verify that a sender actually sent a transaction and it isn't some kind of fraudulent transaction.                                 |


{% endtab %}

{% tab title="Features I won't be including" %}
| Feature                                                                                     | Justification                                                                                                                                       |
| ------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| Proof of work based trust                                                                   | Wastes a lot of computing power and therefore both time and resources (such as electrical energy) which could be used for other, more useful tasks. |
| The limit of only using the blockchain for a singular currency (bitcoins) and nothing else. | Does not allow the blockchain to store other types of data, such as json object data, which this blockchain is based around.                        |
{% endtab %}
{% endtabs %}

## Ethereum



### Overview

Ethereum is the second largest cryptocurrency as of time of writing (Friday 20th May 2022), costing approximately £1,650 GBP per coin. It was launched on the 30th of July 2015 and has grown to a current market cap of £195,873,606,031.48 (\~£200 Bn) in the just under 7 years it has been in use.

### [Consensus Protocol](consensus-protocols/#what-is-a-consensus-protocol)

Ethereum began as a [proof of power](consensus-protocols/#proof-of-power) blockchain but due to the environmental issues it has begun switching to a [proof of stake](consensus-protocols/#proof-of-stake) blockchain and intends to merge the current developer network that runs the proof of stake version of ethereum with the main network that uses proof of power sometime in August this year (2022) although that date has already been postponed over a year so it may be completed at a later date. Because Ethereum is currently undergoing a transition to proof of stake and by the time you are reading this is should have been completed I will be referring to Ethereum's consensus protocol as proof of stake for the remainder of this project.
