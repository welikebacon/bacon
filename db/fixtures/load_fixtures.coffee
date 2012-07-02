#!/bin/env node


dbconfig = require('../../config').db
fixtures = require('pow-mongodb-fixtures')
fixtures_client = fixtures.connect dbconfig.db, 
	host: dbconfig.host
	port: dbconfig.port

fixtures_client.load require('./users'), -> console.log "loaded"
