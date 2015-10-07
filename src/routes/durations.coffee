Duration = require '../models/durations'
_ = require 'underscore'

class Durations
	constructor: (router, resource) ->
		@router   = router
		@resource = resource 

		@router.get "/",  get

	get = (req, res) ->
		Duration.find {}
		.sort 'minutes'
		.exec (e, docs) ->
			if e
				res.status(500).json e
			else
				res.json docs

	get_routes: ->
		@router

module.exports = Durations