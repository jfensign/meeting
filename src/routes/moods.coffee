Mood   = require '../models/moods'
_      = require 'underscore'
config = require '../config'
mw     = require '../middleware'

class Moods
	constructor: (router, resource) ->
		@router   = router
		@resource = resource

		@router.post "/", mw.validator.moods.post, create
		@router.get "/",  get
		config.app._405 @router

	create = (req, res) ->
		mood = new Mood req.body

		mood.save (e, mood) ->
			if e
				res.status(500).json e
			else
				res.json mood

	get = (req, res) ->
		console.log "%s: %s", req.method.toUpperCase(), req.url

	get_routes: ->
		@router

module.exports = Moods