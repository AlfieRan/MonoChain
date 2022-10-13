---
description: >-
  Although this Document refers exclusively to Bitcoin, it can also applied to
  any other proof of power blockchain (possibly with some tweaks)
---

# How Proof of Work Mining Works

Bitcoin mining is a term given to the process of randomly generating numbers, a "nonce" (number used once) to feed alongside the block into the SHA-256 hashing algorithm so as to make the hashed value below a dynamically set threshold.

{% hint style="info" %}
Example SHA256 hash: 000000e943a990e64b08bd3bafc7c1b3fde497e92670f78cd8e9eb27529706f2
{% endhint %}

Because SHA-256 strings do not change in length, always being 64 hex-digits long (4 bits per hex-digit means the total is 256 bits, hence SHA-256) no matter how much data is fed into them, the value of the hash can be used to represent how much work (computing power) has been put into finding a nonce for this block.

In Bitcoin's case it requires the hash of the block to be lower than the hash target, which is a dynamic value defined by the below equation.

![Source - http://blog.geveo.com/Blockchain-Mining-Difficulty#:\~:text=The%20current%20Bitcoin%20blockchain%20requirement,not%20about%20the%20leading%20zeros.&#x20;
2016 Blocks are used because if a block should be generated once per 10 minutes, that's 6 per hour and there's 336 hours per fortnight, therefore multiplying 6 by 336 we get 2016.](<../../.gitbook/assets/image (1) (1) (1) (1).png>)

Therefore by lowering the target that a block's hash needs to be below, the amount of computing power to generate a nonce that meets this requirement grows proportionally. For example, that means that if the hash has to have an additional hex 0 at the start the hash target has become 1/16th of it's previous value and therefore has become 16 times harder to complete.

![Source - https://www.blockchain.com/charts/difficulty](<../../.gitbook/assets/image (2) (1) (1) (2).png>)

The above graph shows the relative difficulty of mining a block on the bitcoin blockchain compared to mining the first block. As of Monday 4th April 2022 it is approximately 28,600,000,000 times harder to mine a block.

It is also important to remember that alongside the popularity of bitcoin growing between its creation in 2009 and now, in 2022, that computing power has also grown substantially.

![Source - https://ourworldindata.org/technological-change](<../../.gitbook/assets/image (2) (1) (1) (1) (1).png>)

The above graph showcasing that the computational capacity of the worlds largest supercomputers has grown by a factor of 246, a very substantial increase in power in only 13 years.

Therefore as bitcoin has shown it can scale with popularity and computing power very well, and should only stop scaling this well once it gets to the point upon which the hash of new blocks are entirely zero, which would make it impossible for the network to increase it's mining difficulty, however the amount of computing power required to do this is so large it is infeasible to imagine and it is more likely that the cryptocurrency ceases use before then. (This is because the more zeros required at the start of the hash the exponentially harder it is to generate)
