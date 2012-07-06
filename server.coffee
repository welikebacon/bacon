#require('coffee-script');

util = require 'util'
express = require 'express' 
MongoStore = require('connect-mongo')(express)
everyauth = require 'everyauth'
config = require './config'
db = require './models/db'
User = require './models/user'
async = require 'async'
readymade = require 'readymade'

everyauth.debug = true

everyauth.everymodule.findUserById (id, callback)->
        User.findById id, callback

#twitter definition
everyauth.twitter.redirectPath '/'
everyauth.twitter.consumerKey config.everyauth.twitter.consumerKey
everyauth.twitter.consumerSecret config.everyauth.twitter.consumerSecret
everyauth.twitter.findOrCreateUser (session, accessToken, accessTokenSecret, twitterUserData)->
    promise = @Promise()
    # no way to add this auth method to an existing user
    # at the moment. Backend can be adapted easily though.
    authMethod =
        protocol: "twitter"
        value: twitterUserData.id
    suggestions = username: twitterUserData.name
    User.findOrCreate authMethod, suggestions, promise
    promise


mongoStore = new MongoStore(config.db)

app = express.createServer()

# Configuration
app.configure ->
    app.use express.bodyParser()
    app.use express.methodOverride()
    #app.use require('less-middleware')({ src: __dirname + '/public/stylesheets' })
    #   app.use require('less-middleware')({ src: __dirname + '/public/stylesheets' })
    #app.use express.static (__dirname + "/public")
    app.use readymade.middleware
        root: 'public'
    app.use express.favicon()
    app.use express.cookieParser()
    app.use express.session { secret: config.secret, store: mongoStore }
    app.use everyauth.middleware()
    app.use app.router
    app.set 'views', __dirname + '/views'
    app.set 'view engine', 'jade'
    app.set 'view options', layout: false

app.configure 'development', ->
    errorHandler = express.errorHandler
        dumpExceptions: true
        showStack: true
    app.use errorHandler

app.configure 'production', ->
    app.use express.errorHandler()

app.get '/', (req, res)->
  res.render 'index',
    title: "Index"
    user: req.user


# Routes
require('./apps/authentication/routes')(app)

runServer = (callback=(->))->
    app.listen 3000, ->
        port = app.address().port
        mode = app.settings.env
        console.log "Express server listening on port #{port} in #{mode} mode"
    callback()

async.series [db.setup, ( (args...)-> User.ensureIndex args...), runServer]


module.exports = app