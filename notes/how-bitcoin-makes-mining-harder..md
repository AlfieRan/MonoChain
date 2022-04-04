# How Bitcoin makes mining harder.

Bitcoin mining is a term given to the process of randomly generating numbers, a "nonce" (number used once) to feed alongside the block into the SHA-256 hashing algorithm so as to make the hashed value below a set threshold, some set amount of zeros at the start of the output.

Because SHA-256 strings do not change in length, no matter how much data is fed into them, the amount of zeros at the start of the hash represents how much work has been put into finding a &#x20;

{% hint style="info" %}
Example SHA256 hash: 000000e943a990e64b08bd3bafc7c1b3fde497e92670f78cd8e9eb27529706f2
{% endhint %}

Therefore by increasing the amount of zeros a block requires to be below this threshold, the amount of computing power to generate a nonce that&#x20;

![Source - https://www.blockchain.com/charts/difficulty](../.gitbook/assets/image.png)
