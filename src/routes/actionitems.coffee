ActionItem = require '../models/actionitems'
_          = require 'underscore'

class ActionItems
	constructor: (router, resource) ->
		@router   = router
		@resource = resource 

		@router.post "/", validate, create
		@router.all "*", (req, res, next) ->
			res.status(405).json
				error: "Method not allowed"

	validate = (req, res, next) ->
		errors

		req.checkBody
			title:
				notEmpty: true
			standUpId:
				notEmpty: true
				isMongoId: true
			isBlocker:
				isBool: true
			resolved:
				isBool: true

		req.checkBody('resolvedBy').optional().isMongoId()
		req.checkBody('resolvedOn', 'Invalid Date. If not resolved, leave blank').optional().isDate()

		errors = do req.validationErrors

		console.log "THESE BE ERRORS"
		console.log errors

		if errors 
			res.status(400).json
				status: 400
				message: errors	
			return

		req.body = _.extend _.pick(req.body,
		'title', 
		'standUpId', 
		'isBlocker', 
		'resolved', 
		'addedBy', 
		'resolvedBy', 
		'resolvedOn')
		, addedBy: req.user.userId

		next()

	del = (req, res) ->
		standup_ids = (id.trim() for id in req.params.ids.split ",")

		Standup.deleteBatch standup_ids, (e) ->
			return res.status(500).json e if e
			
			res.status(200).json {}

	update = (req, res) ->


	create = (req, res) ->
		actionitem = new ActionItem req.body 

		actionitem.save (e, doc) ->
			if e
				console.error e
				res.status(400).json e
			else
				res.json doc

	get_routes: () ->
		@router

module.exports = ActionItems