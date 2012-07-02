#require('coffee-script');

util = require 'util'
express = require 'express' 
MongoStore = require('connect-mongo')(express)
everyauth = require 'everyauth'
config = require './config'
db = require './models/db'
user = require './models/user'



everyauth.debug = true

everyauth.everymodule.findUserById (id, callback)->
    console.log "Findbyid", id
    callback null, {id:id, username:"Smith"}

everyauth.twitter.configure
    consumerKey: config.everyauth.twitter.consumerKey
    consumerSecret: config.everyauth.twitter.consumerSecret
    findOrCreateUser: (session, accessToken, accessTokenSecret, twitterUserData)->
        promise = @Promise()
        # no way to add this auth method to an existing user
        # at the moment. Backend can be adapted easily though.
        authMethod =
            protocol: "twitter"
            userid: twitterUserData.id  
        suggestions = username: twitterUserData.name
        user.findOrCreate authMethod, suggestions, promise
        promise
    redirectPath: '/'

mongoStore = new MongoStore(config.db)

app = express.createServer()

# Configuration
app.configure ->
    app.use express.bodyParser()
    app.use express.static(__dirname + "/public")
    app.use express.favicon()
    app.use express.cookieParser()
    app.use express.session { secret: config.secret, store: mongoStore }
    app.use everyauth.middleware()
    app.use app.router
    app.set('views', __dirname + '/views')
    app.set('view engine', 'jade')


app.configure 'development', ->
    errorHandler = express.errorHandler
        dumpExceptions: true
        showStack: true
    app.use errorHandler

app.configure 'production', ->
    app.use express.errorHandler()


app.get '/', (req, res)->
  console.log(req.user);
  res.render 'home', {'title': 'home'}


# Routes
require('./apps/authentication/routes')(app)

db.setup ->
    # Start the server
    app.listen 3000, ->
        port = app.address().port
        mode = app.settings.env
        console.log "Express server listening on port #{port} in #{mode} mode"


module.exports = app