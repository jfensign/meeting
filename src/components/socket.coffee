models = require '../models'

class Socket
	
	PeopleJoined: (user, data) ->
		models.users.findById user.userId, (e, u) ->
			u.joinStandUp data.StandUp, () ->
				u.save()

	PeopleLeft: (user, data) ->
		models.users.findById user.userId, (e, u) ->
			u.leaveStandUp data.StandUp, () ->
				u.save()

	PeopleOrderChanged: (user, data) ->

	ActionItemsUpdated: (user, data) ->

	StandUpStarted: (user, data) ->



module.exports = new Socket