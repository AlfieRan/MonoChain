# 2.2.9 Cycle 9 - Protocol Updates

* Conceptualised voting and how system rules are going to work.
  * Allows block defined rules to be changed diplomatically and removes control from any individual.
* Transaction speed (cause of planning out voting in more detail)
  * This is needed so as to promote fast block development without creating blocks with very few transactions, this way is the best of both worlds, it promotes somewhere in between.

## Design

A lot of the work so far has been based around the software, in the form of the node program and the webportal, however there is a third portion of this project which is equally valuable to its creation, the monochain protocol itself.

Now the reason I'm only just talking about the protocol this late into the project is because a lot of the initial sections were theorised and planned in the [analysis part of this project](broken-reference). However due to the complexity of a blockchain protocol, and hence the monochain protocol, this was only the major framework of the protocol and the details need to be ironed out as the project proceeds.&#x20;

In this cycle the two sections of the protocol to be looked more into are:

* The regulation of the speed at which blocks are created
* The initial theorisation of voting on blockchain parameters.

### Objectives

As specified in the above there will be two main areas of the protocol to be examined and improved. Those areas being:

* Regulating block production speed
* Voting on blockchain parameters

#### Let's start with the regulation of the speed at which blocks are produced

In order for the blocks to be properly propagated amongst all the nodes in the network, blocks cannot just be created thousands of times per second and have it hoped that all the nodes receive them, hence some kind of regulation method needs to be created to limit the amount of blocks created per time period. Initially this will be purely a conceptual, protocol change, but time permitted should be implemented into the node software in a future cycle.

* [ ] Conceptualise how blocks are going to be regulated
* [ ] Don't use a constant timing based method (e.g. only allowing a new block every 10s) as this could lead to multiple nodes publishing new blocks as soon as that time period completes, causing forks.

#### Leading on from here is the voting concept

Voting is essential to any decentralised power structure and since this blockchain will be a decentralised structure that will most likely require updates and adjustments into the future, it makes sense for the monochain to allow voting to change the specifics of the fundamentals of which it is based upon.

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
