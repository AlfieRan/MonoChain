# 2.2.14 Cycle 14 - Adding Web sockets for dynamic Nodes.

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

Development moment

### Outcome

#### The test code

This was the test code for confirming that shared variables do in fact do what I needed them to do.

```v
struct Info {
	test int
}

struct App {
	vweb.Context
	info shared Info
}
 
pub fn start(config configuration.UserConfig) {
	info := Info{test: 0}
	app := App{info: info}
	api := go vweb.run(app, config.port) // start server on a new thread
	
	// there's some other code here but it isn't important in this cycle
	
	api.wait()	// bring server process back to main thread
}

["/test"]
pub fn (mut app App) test() vweb.Result {
	println(app)
	mut result := ""
	lock app.info {
		cur := app.info.test
		result = json.encode(cur)
		app.info = Info{test: cur + 1}
	}
	return app.text(result)
}
```

Objective 2

```
code
```

### Challenges

Challenges faced in either/both objectives

Code that the compiler was creating with the removed function "I\_voidptr\_to\_Interface\_log\_\_Logger"

```c
.logger = HEAP(log__Logger, /*&log.Logger*/I_voidptr_to_Interface_log__Logger(HEAP(voidptr, (((void*)0)))))
```

Code that should've been generated

```c
.logger = HEAP(log__Logger, /*&log.Logger*/I_log__Log_to_Interface_log__Logger(((log__Log*)memdup(&(log__Log){.level = log__Level__info,.output_label = (string){.str=(byteptr)"", .is_lit=1},.ofile = (os__File){.cfile = 0,.fd = 0,.is_opened = 0,},.output_target = 0,.output_file_name = (string){.str=(byteptr)"", .is_lit=1},}og__Log))))
	
```

## Testing

### Tests

| Test | Instructions                                                                                   | What I expect                                                                                 | What actually happens                                           | Pass/Fail |
| ---- | ---------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- | --------------------------------------------------------------- | --------- |
| 1    | Run the test code, navigate to "http://localhost:8000/test"                                    | A number to be displayed which increases by 1 for each page refresh.                          | as expected                                                     | Pass      |
| 2    | Send a message using web sockets                                                               | The message sent to be transmitted and received successfully.                                 |                                                                 |           |
| 3    | Send multiple messages for a prolonged period of time (once every 0.5 seconds for 30 seconds). | The messages to continue to be transmitted and validated consistently during the entire time. | Ran successfully for approximately 10 seconds and then crashed. | Fail      |

### Evidence

#### Test 1

{% embed url="https://youtu.be/PfIk16whvgA" %}

**Test 3**

Sending messages once every 0.5 seconds for a prolonged period of time.

<figure><img src="../.gitbook/assets/image (5).png" alt=""><figcaption></figcaption></figure>
