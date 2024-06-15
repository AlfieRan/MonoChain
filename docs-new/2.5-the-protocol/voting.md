# Voting

Voting is essential to the way the Monochain works, as it creates a truly decentralised system of which no individual party has control of whilst ensuring the system can adapt and change into the future.

The way in which this will work is the following:

1. A mining Node will register a vote by creating two new voting "wallets", where the public key for the wallets will be in the format "vote:\[uid]:true" and "vote:\[uid]:false" and there is no private key.
2. Users will then vote by sending a "vote token" to one of the two wallets in the pair, where they do not need any vote tokens to send a vote token, they just cannot send a token to the same vote more than once and cannot send a vote token to both "wallets".
3. If a vote receives less than 100 votes or 75% of the quantity of votes from the previous vote then it is immediately cancelled as invalid (although as this is a system rule it can be changed through voting).
4. If a vote receives a majority of no votes then the vote is cancelled and nothing happens, if the vote receives a majority yes vote then the change it wishes to put into place is granted and that change is made to the system wallet.
5. Initially votes cannot exceed more than once per 1209600 seconds (two weeks).

### Timeline

Conceptualised in Cycle 5 (August 2022)
