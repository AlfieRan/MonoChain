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

Since the web sockets have two types of connections, servers and clients, some kind of wrapper function will be required to prevent all parts of the code from having to have two methods for both objects and instead simplifying it to being called on the wrapper object and then that object handling how to deal with the client and server respectively.

The other key section of code that needs to be developed is how the web-socket object is then passed around the code to various api endpoint functions, as these api endpoints will need to be able to send their own web-socket messages for functionality such as message forwarding. To do this, I plan to simply pass the object as a "shared" parameter into the api generator so that the endpoints can use it as required, however since I am completely sure on how V will handle this I will  first write a test program which will be shown below in the outcome section.

The reason that I didn't use the shared parameter when dealing with the configuration object earlier on is because when I last looked into this type of parameter the Vweb module didn't fully support it, thus it caused some weird side effects, but Vweb should now support shared parameters to their full extent so it should all work as expected.

### Outcome

#### The test code

This was the basic test code I wrote in order to confirm that shared parameters do in fact work as they are described to and that I can therefore use them to pass the web-socket connections around to the various api endpoints as required.

This code will be ran and demonstrated in test 1 of the testing section further along in this cycle.&#x20;

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

#### The web socket client

This code handles the ability for multiple client web-socket connections and will be used by private nodes that do not intend to host servers for other clients to connect to and hence need the ability to create and store multiple client connections whilst still being able to create connections easily.

```v
// Found at /packages/node/src/modules/server/ws_client.v
module server

// internal modules
import database
import configuration

// external
import net.websocket
import log

// this represents the "client" object that can hold multiple connections
struct Client {
	db database.DatabaseConnection	[required]
	config configuration.UserConfig [required]
	mut:
		connections []websocket.Client
}

// this initiates the original client object without any connections
pub fn start_client(db database.DatabaseConnection, config configuration.UserConfig) Client {
	c := Client{
		db: db
		config: config
		connections: []websocket.Client{}
	}

	println("[Websockets] Created client.")
	return c
}

// this is ran on the client object and connects to a server
pub fn (mut c Client) connect(ref string) bool {
	// create a new client connection object
	mut ws := websocket.new_client(ref, websocket.ClientOpt{logger: &log.Logger(&log.Log{
		level: .info
	})}) or {
		eprintln("[Websockets] Failed to connect to $ref\n[Websockets] Error: $err")
		return false
	}

	// setup logging functions
	ws.on_open(socket_opened)
	ws.on_close(socket_closed)
	ws.on_error(socket_error)
	
	// setup messaging function
	println('[Websockets] Setup Client, initialising handlers... ')
	ws.on_message_ref(on_message, &c)
	
	// actually connect to the server
	ws.connect() or {
		eprintln("[Websockets] Failed to connect to $ref\n[Websockets] Error: $err")
	}
	// start listening to the connection on a new thread
	go ws.listen()

	// add the connection to the client's connection array.
	c.connections << ws
	println('[Websockets] Connected to $ref')
	return true
}

pub fn (mut c Client) send_to_all(data string) bool {
	// this loops through all connections and sends a message to each one
	// then waits for the threads those messages were initiated on to return.
	
	println("[Websockets] Sending a message to all ${c.connections.len} clients")
	mut threads := []thread bool{}
	for mut connection in c.connections {
		println("[Websockets] Starting a new thread to send a message to $connection.id")
		threads << go send_ws(mut connection, data)
	}

	println("[Websockets] Waiting for all threads to finish")
	threads.wait()
	println("[Websockets] All threads finished, message sent.")
	return true
}

fn socket_opened(mut c websocket.Client) ? {
	// this runs everytime a new socket connection is opened.
	println("[Websockets] Socket opened")
}

fn socket_closed(mut c websocket.Client, code int, reason string) ? {
	// this runs everytime a socket connecction is closed
	println("[Websockets] Socket closed, code: $code, reason: $reason")
}

fn socket_error(mut c websocket.Client, err string) ? {
	// this runs any time an error occours with a socket connection.
	println("[Websockets] Socket error: $err")
}
```

#### The web socket server

```v
// Found at /packages/node/src/modules/server/ws_server.v
module server

// internal
import database
import configuration

// external
import net.websocket
import log

struct Server {
	db database.DatabaseConnection	[required]
	config configuration.UserConfig [required]
	mut: 	
		sv websocket.Server	[required]
}

pub fn start_server(db database.DatabaseConnection, config configuration.UserConfig) Server {
	mut sv := websocket.new_server(.ip, config.ports.ws, "", websocket.ServerOpt{
		logger: &log.Logger(&log.Log{
			level: .info
		})
	})
	mut s := Server{db, config, sv}

	println("[Websockets] Server initialised on port $config.ports.ws, setting up handlers...")
	sv.on_message_ref(on_message, &s)
	
	println("[Websockets] Server setup on port $config.ports.ws, ready to launch.")
	// this does not start listening to the server, need to do that later
	return s
}

pub fn (mut S Server) listen() {
	S.sv.listen() or {
		eprintln("[Websockets] ERROR - Error listening on server: $err")
		exit(1)
	}
}

pub fn (mut S Server) send_to(id string, data string) bool {
	println("[Websockets] Sending a message to $id")

	mut cl := S.sv.clients[id] or {
		eprintln("[Websockets] Client $id not found")
		return false
	}

	cl.client.write_string(data) or {
		eprintln("[Websockets] Failed to send data to client $id")
	}

	println("[Websockets] Message sent to $id")
	return true
}

pub fn (mut S Server) send_to_all(data string) bool {
	len := S.sv.clients.keys().len
	println("[Websockets] Sending a message to all $len clients")

	mut threads := []thread bool{}
	for id in S.sv.clients.keys() {
		println("[Websockets] Sending message to socket with $id")
		threads << go S.send_to(id, data)
	}
	
	println("[Websockets] Waiting for all threads to finish")
	threads.wait()
	println("[Websockets] Message sent to all clients")
	return true
}


```

#### The generic web socket object that wraps the client and server.

```v
// Found at /packages/node/src/modules/server/ws_generic.v

module server

// internal
import database
import configuration

// external
import net.websocket
import json

struct WS_Error {
	code int
	info string
}

struct WS_Success {
	info string
}

type WS_Object = Broadcast_Message | WS_Error | WS_Success

// websocket server

struct Websocket_Server {
	is_disabled bool
	is_client bool	[required]
	db database.DatabaseConnection	[required]
	mut:
		c Client
		s Server
}

pub fn (mut ws Websocket_Server) send_to_all(msg string) bool {
	if ws.is_disabled {
		eprintln("[Websockets] Message requested to send but websockets are disabled.")
		return false
	}


	println("[Websockets] Sending message to all clients...")
	if ws.is_client {
		println("[Websockets] Sending messages as a client...")
		return ws.c.send_to_all(msg)
	} else {
		println("[Websockets] Sending messages as a server...")
		return ws.s.send_to_all(msg)
	}
	return false
}

pub fn (mut ws Websocket_Server) connect(ref string) bool {
	if ws.is_disabled {
		eprintln("[Websockets] Connection requested to send but websockets are disabled.")
		return false
	}

	println("[Websockets] Connecting to server $ref")
	if ws.is_client {
		println("[Websockets] Connecting as a client...")
		return ws.c.connect(ref)
	} else {
		println("[Websockets] Cannot connect as a server, only clients can connect to servers.")
		return false
	}

	return false
}

pub fn (mut ws Websocket_Server) listen() {
	if ws.is_disabled {
		eprintln("[Websockets] request to listen but websockets are disabled.")
		return
	}

	if !ws.is_client {
		println("[Websockets] Listening for connections...")
		ws.s.listen()
	} else {
		println("[Websockets] Cannot listen as a client, only servers can listen for connections.")
		return
	}
}

// generic functions

pub fn gen_ws_server(db database.DatabaseConnection, config configuration.UserConfig) Websocket_Server {
	if !config.advanced.ws_enabled {
		eprintln("[Websockets] Requested to generate a server but websockets are disabled.")
		return Websocket_Server{
			is_disabled: !config.advanced.ws_enabled,
			is_client: true,
			db: db,
		}
	}

	if config.self.public {
		println("[Websockets] Node is public, starting server...")
		return Websocket_Server{
			is_client: false,
			db: db,
		 	s: start_server(db, config)
		}
	} else {
		println("[Websockets] Node is private, starting client...")
		return Websocket_Server{
			is_client: true,
			db: db,
		 	c: start_client(db, config)
		}
	}

	eprintln("[Websockets] Error starting websocket server.")
	exit(1)
}

fn on_message(mut ws websocket.Client, msg &websocket.Message, mut obj &Websocket_Server) ? {
	println('[Websockets] Received message: $msg')
	match msg.opcode {
		.text_frame {
			parsed_msg := json.decode(WS_Object, msg.payload.str()) or {
				eprintln('[Websockets] Could not parse message: $err')
				return
			}

			if parsed_msg is Broadcast_Message {
				println('[Websockets] received broadcast message: $parsed_msg')
				valid := broadcast_receiver(obj.db, mut obj, parsed_msg)

				if valid == .ok {
					println('[Websockets] Broadcast message was valid')
					send_ws(mut ws, json.encode(WS_Success{"Broadcast message was valid"}))				
				} else {
					println('[Websockets] Broadcast message was invalid')
					send_ws(mut ws, json.encode(WS_Error{1, "Broadcast message was invalid"}))
				}
			} else if parsed_msg is WS_Success {
				println("[Websockets] Received success message: $parsed_msg.info")
			} else if parsed_msg is WS_Error { 
				eprintln('[Websockets] Received error message: $parsed_msg.info')
			} else {
				eprintln('[Websockets] Received unknown message: $parsed_msg')
			}
		}
		else {
			println('[Websockets] received unknown message: $msg')
		}
	}
}

fn send_ws(mut ws websocket.Client, msg string) bool {
	ws.write_string(msg) or {
		eprintln('[Websockets] Could not send message: $err')
		return false
	}
	return true
}


```

The commit for this code is available [here](https://github.com/AlfieRan/MonoChain/blob/3388fb2b4889f92b5f6cff9d4746c641885188d1/packages/node/src/modules/server/).

## Challenges

The main challenge faced through the development of this cycle was not one of my own code, but instead of the language that I am using's standard library. In particular, the `log` module that is included within it.

#### The Problem

The error in particular was due to a the generation of a function to generate a 'logger' (an object that allows for the logging of the program in a log file or terminal output) which upon being fed the value 'nil' (representing nothing) should generate a default logger using the Log object, however in certain circumstances it was instead attempting to generate the logger from a `voidptr` object - which is just an empty object in C.

This happens because Vlang is built on top of the low level language C, and therefore when it is compiled, the code gets compiled from V to C and then from C to an executable for whatever platform is being targeted.

This is the C code being generated by Vlang.

```c
.logger = HEAP(log__Logger, /*&log.Logger*/I_voidptr_to_Interface_log__Logger(HEAP(voidptr, (((void*)0)))))
```

This is the C code that should've been generated.

```c
.logger = HEAP(log__Logger, /*&log.Logger*/I_log__Log_to_Interface_log__Logger(((log__Log*)memdup(&(log__Log){.level = log__Level__info,.output_label = (string){.str=(byteptr)"", .is_lit=1},.ofile = (os__File){.cfile = 0,.fd = 0,.is_opened = 0,},.output_target = 0,.output_file_name = (string){.str=(byteptr)"", .is_lit=1},}og__Log))))
	
```

#### The fix

Although completing the actual fix was fairly quick and easy, finding what was broken in the first place was a lot more complicated. This involved writing testing files to ensure it was actually a compiler issue and not just my code, then careful reading of the semi-compiled C files generated by Vlang to find the compiler error, then changing pieces of code in the compiler one line at a time to figure out how to prevent it from happening until eventually - after about 3 days of repetitive bug hunting - I stumbled upon what I needed.

The quick fix for this was relatively simple and only required changing the default value for the logger inside the net.websocket module (which is where the logger module was incorrectly generating code) from `nil` to a `Log object` although this didn't actually fix the root problem, it did solve it enough for me to carry on working on my project and fixing the root problem would've been far outside the scope of this project.

After creating this fix and validating that it didn't break anything else, I realised that other developers with less experience in this kind of thing might be having this issue and be getting completely stuck so I decided to share my edited version of the compiler by submitting a 'pull request' to the Github repository. This allows the team that make the Vlang compiler to approve my change and make it part of the official Vlang compiler.

One of the members of the Vlang team then confirmed that the bug I had discovered did in fact exist, validated that my version didn't break anything else, created a test to stop it happening in the future and then merged my changes into the compiler. This means that as a byproduct of this A Level project I have contributed to the compiler of a language used by hundreds of thousands of people!

#### The code I changed

Here are the two fixes I made, the top image looks like I changed a lot more than I actually did but that's just due to me changing the code comments slightly.

<figure><img src="../.gitbook/assets/image (14).png" alt=""><figcaption><p>The code I changed (green is my code and red is what it replaced)</p></figcaption></figure>

<figure><img src="../.gitbook/assets/image (3).png" alt=""><figcaption><p>The code I changed (green is my code and red is what it replaced)</p></figcaption></figure>

<figure><img src="../.gitbook/assets/IMG_7004.png" alt=""><figcaption><p>A screenshot of my commit in the official V git repository.</p></figcaption></figure>

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
