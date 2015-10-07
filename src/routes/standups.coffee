mw           = require '../middleware'
Participants = require '../models/participants'
Standup 	 	  = require '../models/standups'
User     	   = require '../models/users'
_            = require 'underscore'

class StandUps
	constructor: (router, resource) ->
		@router   = router
		@resource = resource 

		@router.post '/', mw.validator.standups.post, create
		@router.put '/:id', mw.validator.standups.post, update
		@router.delete '/:ids', del
		@router.get '/',  get
		@router.all '*', (req, res) ->
			res.status(405).json
				error: 'Method not allowed.'

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
			user.standups (e, standups) ->
				if e
					res.status(500).json e
				else
					res.json standups

	del = (req, res) ->
		standup_ids = (id.trim() for id in req.params.ids.split ',')

		Standup.deleteBatch standup_ids, (e) ->
			return res.status(500).json e if e
			
			res.status(200).json {}

	update = (req, res) ->


	create = (req, res) ->
		req.body.participants.push req.body.scrumMaster

		standup = new Standup req.body 

		standup.save (e) ->
			if e
				res.status(400).json e
			else
				res.json standup

	get_routes: ->
		@router

module.exports = StandUps