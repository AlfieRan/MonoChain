# \[needs code] 2.2.10 Cycle 10 - Basic Inter-Nodal Communication

* STOP NODES FROM JUST SIGNING ALL DATA SENT THEIR WAY -> MASSIVE SECURITY FLAW
* Convert pong route from a get request to a post request
* move pong request data from query to body
* create an info getter that just asks a node for all it's info in more detail.

## Design

### Objectives

The objective for this cycle is to turn the [basic inter-nodal communication from Cycle 6](2.2.6-cycle-6-setting-up-inter-nodal-communication.md) into something a little more advanced, allowing Nodes to start using post requests rather than get requests so that the data can be supplied within the body of the request, and other similar quality of life upgrades.

Alongside this there is also a very bad security flaw with the way in which Nodes sign data sent to their pong routes, and that is that they will just sign anything sent their way. This means that node A could just ask node B to sign a transaction that gives all of B's assets to A and then B would just do it and send the signed transaction back to A. This is obviously bad and needs to be fixed.

* [ ] Make nodes check the data sent to their pong route and only sign it if it is a dateTime string.
* [ ] Convert pong request from a get request to a post request.
* [ ] Move pong request data from the query of the request to the body.
* [ ] Create an info getter route that asks a node for all of its information - will be useful in the future.

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

#### Only signing date-time objects

Luckily implementing this, and dramatically improving the node software's current security, should actually be pretty easy. All the code will need to do is attempt to parse the message received within the handshake (ping/pong) request as a date-time object and if it succeeds, then the message is okay to be signed and if not then fail the request and do not sign it.

Parsing date-time objects is different for every language and standard library so for this pseudocode the function `Parse_Date` will represent a function which takes a string in the format `YYYY-MM-DD hh:mm:ss` and either returns a date-time object in some format or errors out.

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
