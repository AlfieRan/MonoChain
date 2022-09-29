# 2.2.11 Cycle 11 - Remembering Nodes

## Design

### Objectives

The next step to building a network in which nodes can successfully communicate across is for the node software to remember which nodes it has come into contact with previously so that it can send messages it receives from other nodes onto it's remembered nodes in the future.

This is what will create the networking effect that allows for messages to flow throughout the entire network without having to have any form of central server.

<figure><img src="../.gitbook/assets/image (2) (1) (3).png" alt=""><figcaption><p>A diagram showing how communication across the network works.</p></figcaption></figure>

The diagram above shows how such a message flow would work, with node 'a' wanting to send a message across the network which will end up with every node having read it, including node 'g' at the opposite side. The way in which this will work can be explained using a few stages:

1. Node 'a' sends the message to all nodes it's aware of, in this case only node 'b', this is represented by green arrow and number.
2. Node 'b' receives the message, checks it's valid, approves it and then forwards it on to all the nodes it knows (apart from the node it just came from - 'a'), this is blue.
3. Nodes 'c' and 'd' receive the message from 'b', validate it and then forward it on to the nodes they know of, this is pink.
4. Nodes 'e' and 'f' both receive the message, validate it and then begin to send it on to any node they know of that didn't send them the message. Although in this case they don't know that the other node has already seen the message so they send it on anyway. Since node 'f' is also connected to node 'g' this does mean that 'g' is also sent the message. This is represented by the colour orange.
5. All nodes have now seen the message and therefore the cycle is complete.

#### Therefore the primary objectives this cycle are:

* [ ] Nodes should store references to other Nodes.
* [ ] Nodes should send handshakes to nodes upon connecting to the network.
* [ ] Nodes should send a handshake back to any node that sends them one that they haven't seen before.

### Usability Features

* Feature 1
* Feature 2

### Key Variables

| Variable Name                      | Use                                                                                                                                                                                                           |
| ---------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| <pre><code>References</code></pre> | This is the references object which holds all the known references that a node has encountered as well as some functionality to check if the node is aware of a specific reference, add a new reference, etc. |
| <pre><code>ref_path</code></pre>   | This is the file path of the file at which the references object is stored and loaded from. This is stored as a parameter within the configuration object.                                                    |

### Pseudocode

Objective 1 solution:

```
```

Objective 2 solution:

```
```

## Development

Although the changes introduced in this cycle were fairly simple to do and didn't take many changes to the rest of the program to start being used properly, they are still very substantial, as the addition of referencing at memorising which nodes a node has come into contact with before is what will allow the network to truly grow and become as interconnected as it will need to be to work properly.

### Outcome

#### Handling References

This piece of code handles the initial definition of the 'References' object and the loading, saving generation of that object. Like most of the rest of the key objects in the codebase the object is saved and loaded in json.

```v
module memory

// internal imports
import utils
// external imports
import json


// This is a simple way of storing the node's memory of other nodes that it's encountered.

pub struct References {
	path string
	mut:
		keys map[string][]u8	// this maps a reference the pub key that it runs using.
		blacklist map[string]bool	// this is a list of pub keys that we've already seen and do not trust. Erased when the node is restarted.
}

fn (Ref References) save() {
	// create a new object to ignore blacklisted keys
	raw := json.encode(References{
		path: Ref.path
		keys: Ref.keys
	})
	utils.save_file(Ref.path, raw, 0)
}

fn new(file_path string) References {
	ref := References{
		path: file_path
		keys: map[string][]u8{},
		blacklist: map[string]bool{},
	}
	ref.save()
	return ref
}

pub fn get_refs(file_path string) References {
	raw := utils.read_file(file_path, true)
	mut refs := new(file_path)	// incase no file or error

	if raw.loaded != false {
		// convert the json data to a References struct.
		refs = json.decode(References, raw.data) or {
			// if the json is invalid, create a new one.
			new(file_path)
		}
	}

	return refs
}
```

#### Using the Reference object

The functions in this block of code allow for other parts of the codebase to add keys to both the standard reference and the blacklist reference simply by supplying the reference (and key for the main reference type). Then also to check if the references object is already aware of a specified reference for use in areas such as the handshake code expanded in [Cycle 10](needs-code-2.2.9-cycle-9-basic-inter-nodal-communication.md).

```v
pub fn (refs References) aware_of(reference string) bool {
	// check if the reference is in the blacklist.
	if refs.blacklist[reference] {
		// we have encountered this reference before and it is blacklisted.
		return true
	}

	// if it is not blacklisted, check if the reference is in the keys.
	if reference in refs.keys {
		// we have encountered this reference before and it is not blacklisted.
		return true
	}

	// we have not encountered this reference before.
	return false
}

pub fn (mut refs References) add_key(reference string, key []u8) {
	// add the key to the keys map.
	refs.keys[reference] = key
	// save the references.
	refs.save()
}

pub fn (mut refs References) add_blacklist(reference string) {
	// add the reference to the blacklist.
	refs.blacklist[reference] = true
	// save the references.
	refs.save()
}
```

#### Using references when receiving a handshake.

This is a piece of code taken from the handshake responder api route that checks if the node has come into contact with the node sending a handshake request before and if not, starts a new handshake to 'get to know' the new node.

```v
println("Handshake Analysis Complete. Sending response...")
// now need to figure out where message came from and respond back to it
refs := memory.get_refs(config.ref_path)
if !refs.aware_of(req_parsed.initiator.ref) {
	println("Node has not come into contact with initiator before, sending them a handshake request")
	// send a handshake request to the node
	start_handshake(req_parsed.initiator.ref, config)
} else {
 	println("Node has come into contact with initiator before, no need to send a handshake request")
}
```

#### Using references when sending a handshake.

This allows the node to remember if a node successfully completed a handshake request - in which case it is added to the main reference map - or unsuccessfully didn't complete the request - in which case the reference is temporarily blacklisted until the node restarts.&#x20;

```v
mut refs := memory.get_refs(config.ref_path)

// this verifies that the received handshake is valid
// signed hash can then be verified using the wallet pub key supplied
if data.message == msg && data.initiator.key == this.self.key {
	if cryptography.verify(data.responder_key, data.message.bytes(), data.signature) {
		// handshake was valid.
		println("Verified signature to match handshake key\nHandshake with $ref successful.")

		// now add them to reference list
		refs.add_key(ref, data.responder_key)
		return true
	}
	
	// handshake signature was not valid
	println("Signature did not match handshake key, node is not who they claim to be.")
	// store a record of the node's reference and temporarily blacklist it
	refs.add_blacklist(ref)
	return false
}

// handshake message was not assembled correctly.
println("Handshake was not valid, node is not who they claim to be.")
println(data)
// node is not who they claim to be, so temporarily blacklist it
refs.add_blacklist(ref)
```

### Challenges

Since the actual logic for this part of the software is somewhat simple, this cycle didn't have many algorithmic based challenges but that doesn't mean it didn't have it's hurdles. In this case the main hurdle was trying to figure out what the reference for a node was and initially I trialled using ip tracking and cryptography signatures to attach a secure method of ensuring that a node was who they said they were. However this didn't work out as the ip tracking wasn't always perfect and this lead to the other testing servers running this version of the node software semi-randomly blacklisting each other at various points.

The solution to this was to realise that as long as any secure requests/responses contain a signature validating that transmission, the node's reference doesn't really need to be secure and can mainly just be used to remember where nodes are on the internet and then anything else can be done using signed messages to and from the referenced node. This means that if a node is lying about it's reference, it won't matter as it will still be signing the messages with a different&#x20;

## Testing

### Tests

| Test | Instructions | What I expect | What actually happens | Pass/Fail |
| ---- | ------------ | ------------- | --------------------- | --------- |
| 1    |              |               |                       |           |
| 2    |              |               |                       |           |
| 3    |              |               |                       |           |

### Evidence

(Images of tests running/results)
