db = require './db'
model = require './model'

class User extends model.Model

    @fromData: (data)->
        new User data
    constructor: (data)->
        @id = data.id
        @username = data.username
        @creationDate = data.creationDate
        @authMethods = data.authMethods
    toJSON: ->
        username: @username
        creationDate: @creationDate
        authMethods: @authMethods
    findFromOAuth: (authMethod)->
        authMethod
    """
    save: ->
        db.client.save 
    create: (parameters)->
        user = User.fromData parameters
        db.collection("User").save user.toData()
        user
    """

findOrCreate = (authMethod, suggestions, promise)->
    """
    authMethod:
        protocol: twitter
        userid: twitterUserData.id  
    suggestions:
        username: twitterUserData.name
    promise: promise
    """
    user = new User
        id: 1 # TODO FIX THIS FAST
        username: suggestions.username
        creationDate: new Date()
        authMethods: [authMethod]
    promise.fulfill user

    
module.exports = 
    User: User
    findOrCreate: findOrCreate
