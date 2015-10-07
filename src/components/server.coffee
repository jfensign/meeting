###
# Require and initialize dependencies
###

express      = require 'express'
config       = require '../config'
app          = express()
server       = require('http').Server app
io           = require('socket.io') server
cookieParser = require 'cookie-parser'
components   = require './'
path = require 'path'

app.use('/static', express.static(path.join(__dirname, '..', '..', '/public')))

class Server 

	constructor: (config, routes, components) ->
		@config   	= config
		@routes   	= routes
		@components = components
		@handlers 	= {}
		return

	get_app: ->
		app

	get_server: ->
		server

	load_route: (resource) ->
		@handlers[resource] = new @routes[resource] express.Router()

		app.use "/api/v#{@config.app.api_version}/#{resource}", (req, res, next) ->
			unless !!~["login", "logout"].indexOf resource
				console.log "Check Authentication"
			else
				console.log "Public Page"

			next()
		, @handlers[resource].get_routes()

	run: ->

		@config.app.config_digest app, io

		for resource in @config.app.resources when @routes[resource]
			@load_route resource

		@config.app._404 app

		io.on 'connection', (socket) ->
			socket.on 'StandupUpdated', (data) ->
				if components.socket[data.EventType]
					components.socket[data.EventType] socket.request.user, data



		server.listen @config.app.port

module.exports = Server