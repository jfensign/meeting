validator = require 'validator'
models    = require '../models'

class Validator

	moods = 
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

			req.body = _.extend _.pick(req.body,
			'standUpId', 
			'mood')
			, _.pick req.user, 'userId'

			next()

		get: (req, res, next) ->
			errors

			


module.exports =
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
				console.log value.length
				
				console.log "QUERYING"
				models.users.count _id: 
					'$in': value
				, (e, c) ->
					console.log e
					console.log c
					if e 
						reject e
					else if c == value.length
						do resolve
					else
						reject "Nonexistent participant"