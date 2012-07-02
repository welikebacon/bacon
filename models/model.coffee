potato = require 'potato'
db = require './db'
mongodb = require 'mongodb'
ObjectID = mongodb.ObjectID
assert = require 'assert'

Model = potato.Potato

    static:
        MAX_PER_REQUEST: 10

        collectionName: -> throw "Not Implemented."

        collection: ->
            collName = potato.pick @collectionName
            db.collection collName

        findById: (itemId, callback)->
            if (typeof itemId == "string")
                itemId = ObjectID itemId
            @collection().findOne({_id: itemId}, callback)

        find: (filter, callback, limit = 10)->
            assert.ok typeof filter == "object"
            @collection().find(filter).limit(limit).toArray callback

module.exports = 
    Model: Model