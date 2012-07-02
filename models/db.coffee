config = require('../config').db

mongodb = require 'mongodb'
server = new mongodb.Server config.host, config.port, auto_reconnect: true
db = new mongodb.Db(config.db, server, {})
client = null

setup = (callback)->
	db.open (error, client)->
	  if error
	  	console.log "Couldn't open connection to MongoDB."
	  	throw error
	  else
	  	console.log "Connected to mongodb."
	  	client = client
	  	callback client

module.exports =
	setup: setup
	collection: (name)->
		 new mongodb.Collection client, collection_name