ObjectId = require('pow-mongodb-fixtures').createObjectId

poulejapon = 
	username: "poulejapon"
	creationDate: new Date 2012, 7, 3
	credentials : [ { "protocol" : "twitter", "value" : 14595797 } ], "_id" : ObjectId("4ff3781d9ce459b514000001")

exports.users = [ poulejapon ]

