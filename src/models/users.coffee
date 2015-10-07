###
_id: int
intranetId: string // unique
name: string
avatar: string // url of avatar
###


mongoose    = require 'mongoose'
q           = require 'q'
Participant = require './participants'
_           = require 'underscore'

Schema 	    = mongoose.Schema
collection  = 'User'
async       = require 'async'

UserSchema = new Schema
	intranetId: { type: Schema.Types.String, unique: true, required: true, dropDups: true, trim: true }
	name      : { type: Schema.Types.String, unique: true, required: true, trim: true }
	avatar    : { type: Schema.Types.String }

UserSchema.methods.joinStandUp = (standUpId, cb) ->
	async.waterfall [
		(_cb) =>
			@model 'Participant'
			.find { standUpId: standUpId }
			.sort '-order'
			.exec (e, participants) =>
				is_first    = (p for p in participants when p.isOnline).length is 0
				participant = p for p in participants when p.userId.toString() == @_id.toString()

				# This logic is "first come first serve" which seems to contradict the screen showing the options for the master to sort members
				# participant.order 	  = if is_first then 0 else _.first(participants).order + 1

				participant.isOnline  = true
				participant.doneSpeaking = false
				participant.save _cb

		(e, _cb) =>
			@model 'StandUp'
			.findById standUpId, (e, standup) ->
				standup.update_mood _cb
		cb
	]


UserSchema.methods.leaveStandUp = (standUpId, cb) ->
	@model 'Participant'
	.find { userId: @_id, standUpId: standUpId }
	.exec (e, participant) ->
		participant.isOnline = false
		participant.order    = -1

		participant.save cb


UserSchema.methods.standups = (cb) ->
	@model 'Participant'
	.find { userId: @_id }
	.populate ['userId']
	.exec (e, docs) =>
		@model 'StandUp'
		.find { participants: $in: _.pluck(docs, '_id') }
		.populate ['participants', 'duration', 'scrumMaster', 'actionItems', 'participants.userId']
		.exec cb

User = mongoose.model collection, UserSchema

module.exports = User