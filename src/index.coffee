throng     = require 'throng'
config     = require './config'
mongoose   = require 'mongoose'
routes 	   = require './routes'
components = require './components'

start = ->
	console.log "Worker Started"

	process.on 'SIGTERM', ->
		console.log 'Worker Terminated'
		process.exit()

	mongoose.connect config.db.endpoint, (e, res) ->
		console.error "MongoDB Error: Error connecting to %s. %s"
		, config.db.endpoint
		, e if e

	server = new components.server config, routes
	server.run()

throng start, config.app.web_concurrency