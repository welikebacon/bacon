run:
	`npm bin`/coffee server.coffee

rundb:
	mongod --dbpath ./db

tests:
	`npm bin`/mocha --recursive --compilers coffee:coffee-script