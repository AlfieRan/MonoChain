module database

// external imports
import os
import time

// config constants
pub const image_name = "monochain-postgresql"
pub const db_name = "postgres"
pub const db_password = "password"

// shell commands
const init_psql_docker = "docker run --name $image_name -p 5432:5432 -e POSTGRES_PASSWORD=$db_password -d postgres"
const start_psql_docker = "docker start $image_name"
const stop_psql_docker = "docker stop $image_name"

// returns whether or not the command executed properly
pub fn sh(cmd string) bool {
  println("[shell] > $cmd")
  executed := os.execute(cmd)
  print("[shell] - $executed.output")

  // 0 means the command executed properly
  return executed.exit_code == 0 
}

pub fn launch(){
  	println("[Database] Launching database...")
  	// try to start the container
  	started := sh(start_psql_docker)

  	if !started {
		println("[Database] No database found, or other error, trying to initialise a new database...")
		initialised := sh(init_psql_docker)

		if !initialised {
			eprintln("\n\n[Database] Could not start or initialise database container, docker is probably not running.")
			exit(300)
		}

		println("[Database] Database initialised successfully.")
  	}
	time.sleep(3 * time.second)
  	println("[Database] Database running.")
}

pub fn stop(){
	println("[Database] Stopping database...")
	stopped := sh(stop_psql_docker)

	if !stopped {
		eprintln("[Database] Failed to stop database, may be due to container not existing, please check docker yourself...")
	} else {
		println("[Database] Stopped database.")
	}
}
