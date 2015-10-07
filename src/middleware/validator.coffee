models    = require '../models'
_     = require 'underscore'

class Validator

	customValidators:
		isArray: (value) ->
			Array.isArray value

		isBool: (value) ->
			return true unless value
			value.toLowerCase() == 'true' or value.toLowerCase() == 'false'

		isMongoId: (value) ->
			return true unless value
			value.match /^[0-9a-fA-F]{24}$/

		isArrayOfParticipants: (value) ->
			return true if value.length == 0
			new Promise (resolve, reject) ->
				models.users.count _id: 
					'$in': value
				, (e, c) ->
					if e 
						reject e
					else if c == value.length
						do resolve
					else
						reject "Nonexistent participant"

	moods:
		post: (req, res, next) ->
			errors

			req.checkBody
				standUpId:
					notEmpty: true
				mood:
					notEmpty: true
					isInt:
						min: 0
						max: 4

			errors = req.validationErrors()

			if errors
				return res.status(400).json
					status: 400
					message: errors	

			req.body = _.extend _.pick(req.body, 'standUpId', 'mood')
			, _.pick req.user, 'userId'

			next()

		get: (req, res, next) ->
			next()

	standups: 
			post: (req, res, next) ->
				errors

				req.checkBody
					title:
						notEmpty: true
					projectGoals:
						notEmpty: true
					callInNumber:
						notEmpty: true
					timeZoneId:
						notEmpty: true
					startTime:
						notEmpty: true
					status:
						notEmpty: true
						isInt: true
						isLength:
							options: [0, 1]
					duration:
						notEmpty: true

				req.checkBody('actionItems', 'Array is required').isArray()
				req.checkBody('participants', 'Array of participants is required').isArray()

				errors = do req.validationErrors

				if errors 
					res.status(400).json
						status: 400
						message: errors	
					return

				req.body = _.extend _.pick(req.body,
				'title', 
				'projectGoals', 
				'callInNumber', 
				'timeZoneId', 
				'startTime', 
				'status', 
				'duration',
				'actionItems', 
				'participants')
				, scrumMaster: req.user.userId

				next()


module.exports = new Validator