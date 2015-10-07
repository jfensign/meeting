session      = require 'express-session'
MongoStore   = require('connect-mongo') session
expressVal   = require 'express-validator'
cookieParser = require 'cookie-parser'
createDomain = require('domain').create
validator    = require 'validator'
bodyParser   = require 'body-parser'
passport     = require 'passport'
passportIO   = require 'passport.socketio'
config       = require './'


class AppConfig

	constructor: (port = 3000, api_version = "1", web_concurrency = 1) ->
		@port = port
		@api_version = api_version
		@web_concurrency = web_concurrency
		@app = null

	resources: [
		'login'
		'logout'
		'standups'
		'moods'
		'notifications'
		'actionitems'
		'users'
		'participants'
		'timezones'
		'durations'
	]

	config_digest: (app, io) ->

		session_store = new MongoStore
			url: config.db.endpoint

		app.use bodyParser.urlencoded
			extended: false

		app.use bodyParser.json()

		app.use expressVal config.validator

		app.use cookieParser config.auth.secret

		app.use session
   			resave: true
   			saveUninitialized: true
   			secret: config.auth.secret
   			store: session_store

		app.use passport.initialize()
		app.use passport.session()

		app.use (req, res, next) ->
   			domain = createDomain()
   			domain.add req
   			domain.add res
   			domain.run -> next()
   			domain.on 'error', (e) -> 
    			next e


		io.use passportIO.authorize
			secret: config.auth.secret
			store: session_store
			success: (data, accept) ->
				accept()
			fail: (data, message, error, accept) ->
				accept(error)

		passport.serializeUser (user, done) ->
   		done null, user

		passport.deserializeUser (user, done) ->
   		done null, user

   	app

	_404: (route) ->
		route.all '*', (req, res) ->
			res.status(404).json
				message: "Not found."
				status: 404


	_405: (route) ->
		route.all '*', (req, res) ->
			res.status(405).json
				message: "Method not allowed."
				status: 405

module.exports = new AppConfig process.env.PORT, process.env.API_VERSION, process.env.WEB_CONCURRENCY