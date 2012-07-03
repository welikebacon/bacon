PIDFILE=./db/data/mongod.lock

run: startdb node_modules
	@`npm bin`/coffee server.coffee

node_modules:
	@echo "Making sure deps are installed"
	@npm install .

tests: startdb
	@`npm bin`/mocha --recursive --compilers coffee:coffee-script

fixture: startdb
	@echo "Loading Fixtures"
	@`npm bin`/coffee db/fixtures/load_fixtures.coffee

deletedb: stopdb
	@echo "Deleting db data"
	@rm -fr ./db/data/*

deletemodules: 
	@echo "Deleting node modules"
	@rm -fr node_modules

clean: deletedb deletemodules node_modules fixture

startdb:
	@if [ -f ${PIDFILE} ]; then \
		echo "Already Started DB"; \
	else \
		echo "Starting DB"; \
		mongod --fork --logpath ./db/log/mongodb.log --logappend -dbpath ./db/data > /dev/null; \
	fi

stopdb:
	@if [ -f ${PIDFILE} ]; then \
		echo "Stopping DB"; \
		echo `test -f ${PIDFILE}`; \
		kill -TERM `cat ${PIDFILE}`; \
		rm -f ${PIDFILE}; \
	else \
		echo "Already stopped."; \
	fi
