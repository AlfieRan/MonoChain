## This is where you would store config files for use in generating docker containers

To do so, run the program from within the `/packages/node/` directory, to generate all the needed config files.
(Or rename exmaple.json to config.json and edit those value)
Then replace any details you need to and run `docker build . -t monochain` to generate a docker image using your own config/tokens/keys
