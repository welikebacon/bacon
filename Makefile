PIDFILE=./db/data/mongod.lock

run: startdb
	@`npm bin`/coffee server.coffee

tests:
	`npm bin`/mocha --recursive --compilers coffee:coffee-script

fixture:
	`npm bin`/coffee db/fixtures/load_fixtures.coffee

clean: stopdb
	rm -fr ./db/data/* 

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
