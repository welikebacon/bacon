
routes = (app) ->
    app.set 'views', __dirname + '/views'

    app.get '/', (req, res) ->
        res.render 'index',
            title: 'Index'
            user: req.user

    app.get '/createDataset', (req, res) ->
        res.render 'createDataset',
            title: 'Create Dataset'

module.exports = routes
