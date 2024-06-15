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

* [x] Nodes should store references to other Nodes.
* [x] Nodes should send handshakes to nodes upon connecting to the network.
* [x] Nodes should send a handshake back to any node that sends them one that they haven't seen before.

### Usability Features

* Storing the node data locally so that nodes will only send messages to a smaller pool of nodes rather than to every node on large, publically accessible lists speeds the network up and limits the number of duplicate messages.
* Once the network reaches the point at which it is large enough that every node knows atleast two other nodes, we can be sure that if any one node shuts down or goes offline any messages will still be distributed across the network.

### Key Variables

| Variable Name                       | Use                                                                                                                                                                                                           |
| ----------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| <pre><code>References
</code></pre> | This is the references object which holds all the known references that a node has encountered as well as some functionality to check if the node is aware of a specific reference, add a new reference, etc. |
| <pre><code>ref_path
</code></pre>   | This is the file path of the file at which the references object is stored and loaded from. This is stored as a parameter within the configuration object.                                                    |

## Pseudocode

### Handling References

This piece of code handles the initial definition of the 'References' object and the loading, saving generation of that object. Like most of the rest of the key objects in the codebase the object is saved and loaded in json.

```
IMPORT utils
IMPORT json


// This is a simple way of storing the node's memory of other nodes that it's encountered.

OBJECT References:
	path
	keys 	// this maps a reference the pub key that it runs using.
	blacklist 	// this is a list of pub keys that we've already seen and do not trust. Erased when the node is restarted.

	FUNCTION save(this):
		// "this" refers to the object itself.
		// create a new object to ignore blacklisted keys
		raw := json.encode({
			path: this.path
			keys: this.keys
		})
		utils.save_file(this.path, raw, 0)
	END FUNCTION

END OBJECT

FUNCTION new(file_path):
	ref = NEW References{
		path: file_path
		keys: {},
		blacklist: {},
	}
	
	ref.save()
	RETURN ref
END FUNCTION

FUNCTION get_refs(file_path):
	raw = utils.read_file(file_path)
	refs = new(file_path)	// incase no file or error

	IF (raw.loaded != false):
		TRY:
			// convert the json data to a References struct.
			refs = json.decode(References, raw.data)
		CATCH:
			// if the json is invalid, create a new one.
			refs = new(file_path)
		END TRY
	END IF

	RETURN refs
END FUNCTION
```

### Using the Reference object

The functions in this block of code allow for other parts of the codebase to add keys to both the standard reference and the blacklist reference simply by supplying the reference (and key for the main reference type). Then also to check if the references object is already aware of a specified reference for use in areas such as the handshake code expanded in [Cycle 10](needs-code-2.2.9-cycle-9-basic-inter-nodal-communication.md).

```
EXTEND OBJECT References:
	FUNCTION aware_of(this, reference):
		// check if the reference is in the blacklist.
		IF (refs.blacklist[reference]):
			// we have encountered this reference before and it is blacklisted.
			RETURN true
		END IF
	
		// if it is not blacklisted, check if the reference is in the keys.
		IF (reference in refs.keys):
			// we have encountered this reference before and it is not blacklisted.
			RETURN true
		END IF
	
		// we have not encountered this reference before.
		RETURN false
	END FUNCTION
	
	FUNCTION add_key(this, reference, key) {
		// add the key to the keys map.
		this.keys[reference] = key
		// save the references.
		this.save()
	END FUNCTION
	
	FUNCTION add_blacklist(this, reference) {
		// add the reference to the blacklist.
		this.blacklist[reference] = true
		// save the references.
		this.save()
	END FUNCTION
END OBJECT EXTEND
```

### Using references when receiving a handshake.

This is a piece of code taken from the handshake responder api route that checks if the node has come into contact with the node sending a handshake request before and if not, starts a new handshake to 'get to know' the new node.

```
OUTPUT "Handshake Analysis Complete. Sending response..."
// now need to figure out where message came from and respond back to it

refs = memory.get_refs(config.ref_path)
IF (NOT refs.aware_of(req_parsed.initiator.ref)):
	OUTPUT "Node has not come into contact with initiator before, sending them a handshake request"
	// send a handshake request to the node
	start_handshake(req_parsed.initiator.ref, config)
ELSE:
 	OUTPUT "Node has come into contact with initiator before, no need to send a handshake request"
END IF
```

### Using references when sending a handshake.

This allows the node to remember if a node successfully completed a handshake request - in which case it is added to the main reference map - or unsuccessfully didn't complete the request - in which case the reference is temporarily blacklisted until the node restarts.&#x20;

```
refs = memory.get_refs(config.ref_path)

// this verifies that the received handshake is valid
// signed hash can then be verified using the wallet pub key supplied
IF (data.message == msg AND data.initiator.key == this.self.key):
	IF (cryptography.verify(data.responder_key, data.message.bytes(), data.signature)):
		// handshake was valid.
		OUTPUT "Verified signature to match handshake key\nHandshake with $ref successful."

		// now add them to reference list
		refs.add_key(ref, data.responder_key)
		RETURN true
	END IF
	
	// handshake signature was not valid
	OUTPUT "Signature did not match handshake key, node is not who they claim to be."
	
	// store a record of the node's reference and temporarily blacklist it
	refs.add_blacklist(ref)
	RETURN false
END IF

// handshake message was not assembled correctly.
OUTPUT "Handshake was not valid, node is not who they claim to be."
OUTPUT data

// node is not who they claim to be, so temporarily blacklist it
refs.add_blacklist(ref)
```



## Development

Although the changes introduced in this cycle were fairly simple to do and didn't take many changes to the rest of the program to start being used properly, they are still very substantial, as the addition of referencing at memorising which nodes a node has come into contact with before is what will allow the network to truly grow and become as interconnected as it will need to be to work properly.

### Outcome

#### Handling References

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

{% tabs %}
{% tab title="Test Table" %}
### Tests

<table><thead><tr><th>Test</th><th>Instructions</th><th>What I expect</th><th>What actually happens</th><th data-type="checkbox">Passed?</th></tr></thead><tbody><tr><td>1</td><td>Create a new references object and log it to the console.</td><td>An empty references object to be logged in the console.</td><td>As Expected</td><td>true</td></tr><tr><td>2</td><td>Create a new references object and log it to the console using the "get_refs" function.</td><td>An empty references object to be logged in the console and a file created with that object.</td><td>As Expected</td><td>true</td></tr><tr><td>3</td><td>Add a test reference to the references object and save it to a test file.</td><td>A references object with the test reference to be saved to the test file.</td><td>As Expected</td><td>true</td></tr><tr><td>4</td><td>Load the test references object created in test 3 and check if the node is still aware of that node using the "aware_of" function.</td><td>The references object to be aware of the test reference.</td><td>As Expected</td><td>true</td></tr><tr><td>5</td><td>Add a test reference to the references object as a blacklisted node and save it to a test file.</td><td>A references object with the test reference as a blacklisted node to be saved to the test file.</td><td>As Expected</td><td>true</td></tr><tr><td>6</td><td>Load the test references object created in test 3 and check if the node is still aware of that node using the "aware_of" function.</td><td>The references object to not be aware of the test reference.</td><td>As Expected</td><td>true</td></tr></tbody></table>


{% endtab %}

{% tab title="Test Code" %}
### Test 1

```v
const test_path = "./test.json"

pub fn test_new_ref_obj() {
	println("\n\n[Memory Test] Testing the creation of a new Reference Object.")
	obj := new(test_path)
	println("[Memory Test] Reference Object created: $obj")
	assert true
}
```

### Test 2

```v
pub fn test_get_refs() {
	println("\n\n[Memory Test] Testing the retrieval of references.")
	refs := get_refs(test_path)
	println("[Memory Test] References retrieved: $refs")
	assert true
}
```

### Test 3

```v
pub fn test_add_ref() {
	println("\n\n[Memory Test] Testing the addition of a reference.")
	mut refs := get_refs(test_path)
	println("[Memory Test] Reference object loaded.")
	refs.add_key("test", []u8{})
	println("[Memory Test] Reference added: $refs")
	assert true
}
```

### Test 4

```v
pub fn test_aware_of() {
	println("\n\n[Memory Test] Testing the awareness of a reference.")
	refs := get_refs(test_path)
	println("[Memory Test] Reference object loaded.")
	aware := refs.aware_of("test")
	println("[Memory Test] Reference awareness: $aware")
	assert aware
}
```

### Test 5

```v
pub fn test_add_blacklisted_ref() {
	println("\n\n[Memory Test] Testing the addition of a blacklisted reference.")
	mut refs := get_refs(test_path)
	println("[Memory Test] Reference object loaded.")
	refs.add_blacklist("test")
	println("[Memory Test] Reference added: $refs")
	assert true
}
```

### Test 6

```v
pub fn test_aware_of_blacklisted() {
	println("\n\n[Memory Test] Testing the awareness of a blacklisted reference.")
	refs := get_refs(test_path)
	println("[Memory Test] Reference object loaded.")
	aware := refs.aware_of("test")
	println("[Memory Test] Reference awareness: $aware")
	assert aware == false
}
```
{% endtab %}

{% tab title="Evidence" %}
### Test 1

<figure><img src="../.gitbook/assets/image (23).png" alt=""><figcaption></figcaption></figure>

### Test 2

<figure><img src="../.gitbook/assets/image (19) (3).png" alt=""><figcaption></figcaption></figure>

### Test 3

<figure><img src="../.gitbook/assets/image (28).png" alt=""><figcaption></figcaption></figure>

### Test 4

<figure><img src="../.gitbook/assets/image (13) (5).png" alt=""><figcaption></figcaption></figure>

### Test 5

<figure><img src="../.gitbook/assets/image (39).png" alt=""><figcaption></figcaption></figure>

### Test 6

<figure><img src="../.gitbook/assets/image (41).png" alt=""><figcaption></figcaption></figure>
{% endtab %}
{% endtabs %}

