# 2.2.12 Cycle 12 - Adding Web sockets for dynamic Nodes.

## Design

### Objectives

Currently the only way a node can contribute to a network is if it either has a static public DNS/IP address that it can be reached at or if it has a direct local connection to a node with such an address. This is a problem because it means that users have to setup some kind of port forwarding, networking tunnel or some other somewhat complicated method just to connect to the network which increases the barrier to entry and is obviously not good.

The solution to this is to introduce web sockets so that "private" nodes without a public address can open a communication tunnel to a public node that can then communicate with it in either direction and therefore continue to use it for the network without having such a high barrier to entry.

* [ ] Convert the main section of the handshake method into a function so that it can be used with either web sockets or http.
* [ ] Add a web sockets object to the references created in the last cycle so that nodes don't get http addresses and web socket ids mixed up.
* [ ] Successfully ensure that the handshake method works for both http and web sockets.

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
