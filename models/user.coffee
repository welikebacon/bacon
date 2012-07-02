
model = require './model'



User = model.Model
    
    static:
        collectionName: "users"

        findOrCreate: (authMethod, suggestions, promise)->
            """
            authMethod:
                protocol: twitter
                userid: twitterUserData.id  
            suggestions:
                username: twitterUserData.name
            promise: promise
            """
            # TODO FIX THIS FAST
            user =
                id: 1
                username: suggestions.username
                creationDate: new Date()
                authMethods: [authMethod]
            promise.fulfill user


module.exports = User
