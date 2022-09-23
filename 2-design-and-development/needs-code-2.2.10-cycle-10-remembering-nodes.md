# 2.2.11 Cycle 11 - Remembering Nodes

## Design

### Objectives

The next step to building a network in which nodes can successfully communicate across is for the node software to remember which nodes it has come into contact with previously so that it can send messages it receives from other nodes onto it's remembered nodes in the future.

This is what will create the networking effect that allows for messages to flow throughout the entire network without having to have any form of central server.

<figure><img src="../.gitbook/assets/image.png" alt=""><figcaption><p>A diagram showing how communication across the network works.</p></figcaption></figure>

The diagram above shows how such a message flow would work, with node 'a' wanting to send a message across the network which will end up with every node having read it, including node 'g' at the opposite side. The way in which this will work can be explained using a few stages:

1. Node 'a' sends the message to all nodes it's aware of, in this case only node 'b', this is represented by green arrow and number.
2. Node 'b' receives the message, checks it's valid, approves it and then forwards it on to all the nodes it knows (apart from the node it just came from - 'a'), this is blue.
3. Nodes 'c' and 'd' receive the message from 'b', validate it and then forward it on to the nodes they know of, this is pink.
4. Nodes 'e' and 'f' both receive the message, validate it and then begin to send it on to any node they know of that didn't send them the message. Although in this case they don't know that the other node has already seen the message so they send it on anyway. Since node 'f' is also connected to node 'g' this does mean that 'g' is also sent the message. This is represented by the colour orange.
5. All nodes have now seen the message and therefore the cycle is complete.

* [ ] Nodes should store references to other Nodes.
* [ ] Nodes should send handshakes to nodes upon connecting to the network.
* [ ] Nodes should send a handshake back to any node that sends them one that they haven't seen before.

### Usability Features

* Feature 1
* Feature 2

### Key Variables

| Variable Name | Use |
| ------------- | --- |
|               |     |
|               |     |
|               |     |

### Pseudocode

Objective 1 solution:

```
```

Objective 2 solution:

```
```

## Development

Most of the development for this cycle was just setup, to get everything I need for this project up and running and building out the structure of the codebase in order to make the actual programming as smooth as possible.

### Outcome

Objective 1

```
code
```

Objective 2

```
code
```

### Challenges

Challenges faced in either/both objectives

## Testing

### Tests

| Test | Instructions | What I expect | What actually happens | Pass/Fail |
| ---- | ------------ | ------------- | --------------------- | --------- |
| 1    |              |               |                       |           |
| 2    |              |               |                       |           |
| 3    |              |               |                       |           |

### Evidence

(Images of tests running/results)
