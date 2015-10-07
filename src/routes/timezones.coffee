Participant  = require '../models/participants'
Standup 	 = require '../models/standups'
User     	 = require '../models/users'

class Participants
	constructor: (router, resource) ->
		@router   = router
		@resource = resource 

		@router.post "/", post
		@router.get "/",  get

	post = (req, res) ->
		console.log "%s: %s", req.method.toUpperCase(), req.url

	get = (req, res) ->
		errors

		req.checkQuery('userId', 'Required Query Parameter').notEmpty()

		errors = do req.validationErrors

		if errors 
			res.status(400).json
				status: 400
				message: errors	
			return

		User.findById req.query.userId, (e, user) ->
			console.error e
			user.standups (e, standups) ->
				console.error e
				console.log standups

				if e
					res.status(500).json e
				else
					res.json standups

	get_routes: ->
		@router

module.exports = Participants