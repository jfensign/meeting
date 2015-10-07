models     = require '../models'
validation = require 'express-validator' 
_          = require 'underscore'

class Login
	constructor: (router, resource) ->
		@router   = router
		@resource = resource 

		@router.post "/",  post
		@router.get "/", post
		@router.all "*", (req, res) ->
			res.status(405).json
				status: 405
				error: "Method Not Allowed"

	post = (req, res) ->
		token_promise
		errors
		#Query Parameters: The user’s IBM ID, password and device id.
		req.checkQuery('username', 'Required Query Parameter').notEmpty()
		req.checkQuery('deviceId', 'Required Query Parameter').notEmpty()
		req.checkQuery('password', 'Required Query Parameter').notEmpty()

		errors = do req.validationErrors

		if errors 
			res.status(400).json
				status: 400
				message: errors	
			return

		token_promise = models.login.perform _.pick req.query
		, 'username'
		, 'deviceId'
		, 'password'

		token_promise.then (doc) ->	
			response = 
				userId     : doc._id.toString()
				username: req.query.username
				token   : doc.token

			req.login response, ->  
				res.json response
		, (error) ->
			res.status(401).json error

	get_routes: ->
		@router

module.exports = Login