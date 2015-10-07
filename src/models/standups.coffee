###
_id: int
title: string
projectGoals: string
callInNumber: string
timezoneId: int // references Timezone._id
startTime: time // the scheduled time to start the standup, note we only need time, date part is not needed since a standup happens every day at the same time
status: int // status can be “0 - Not Running”, “1 - Running Now”
duration: int // references Duration._id
scrumMaster: int // references User._id
###


mongoose     = require 'mongoose'
Schema       = mongoose.Schema
collection   = 'StandUp'
async        = require 'async'
User         = require './users'
Participant  = require './participants'
Notification = require './notifications'
ActionItem   = require './actionitems'
_            = require 'underscore'
q            = require 'q'

StandUpSchema = new Schema
	title		 : { type: Schema.Types.String, unique: true }
	projectGoals : { type: Schema.Types.String }
	callInNumber : { type: Schema.Types.String }
	timezoneId   : { type: Schema.Types.ObjectId, ref: 'Timezone' }
	startTime    : { type: Schema.Types.Date }
	status       : { type: Schema.Types.Number, default: 0 }
	duration     : { type: Schema.Types.ObjectId, ref: 'Duration' }
	scrumMaster  : { type: Schema.Types.ObjectId, ref: 'User' }
	participants : [{ type: Schema.Types.ObjectId, ref: 'Participant' }]
	actionItems  : [{ type: Schema.Types.ObjectId, ref: 'ActionItem' }]
	mood         : { type: Schema.Types.Number, default: null }

StandUpSchema.statics.findAndModify = (query, sort, doc, options, cb) ->
  @collection.findAndModify query, sort, doc, options, cb

 StandUpSchema.statics.deleteBatch = (ids, cb) ->
 	@model collection.find({ _id: { $in: ids } }).exec (e, docs) ->
 		async.forEach docs, (doc, _cb) ->
 			doc.remove()
 			_cb()
 		, cb

StandUpSchema.methods.update_mood = (cb) ->
	@model 'Participant'
	.find { standUpId: @_id }
	.exec (e, participants) =>
		async.map participants
		, (participant, _cb) =>
			participant.mood 5, (e, moods) =>
				_cb(null, if moods.length is 0 then [0,4] else (m.mood for m in moods))
		, (e, result) =>
			return cb e if e
			result = _.flatten result
			@mood = ~~((result.reduce (a, b) -> a + b) / result.length)
			@save cb

StandUpSchema.pre 'remove', (next) ->
	async.forEach [Notification, Participant, ActionItem]
	, (model, cb) =>
		model.find { standUpId: @._id }
		.remove cb
	, next
	
StandUpSchema.pre 'save', (next) ->
	participants = @participants = _.uniq @participants

	async.forEach @participants
	, (participant, cb) =>
		User.findById participant, (e, u_doc) ->
			return cb e if e
			save_participant u_doc, participant, cb
	, (e) =>
		@participants = participants
		next()

	notify_participant = (p_doc, cb) =>
		notif = new Notification _.pick p_doc.value, 'standUpId', 'userId'
		notif.save cb

	save_participant = (user_doc, participant, cb) =>
		#When craeting a new standup, participants array contains user fields.
		return cb null, true unless user_doc

		Participant.findAndModify
			userId: user_doc._id,
			standUpId: @_id
		, []
		, { 
			userId: user_doc._id
			standUpId: @_id
			order: @participants.indexOf participant
		  }
		, { upsert: true, new: true }
		, (e, p_doc) =>
			participants[~~p_doc.value.order] = p_doc.value._id unless e
			notify_participant p_doc, cb

StandUp = mongoose.model collection, StandUpSchema

module.exports = StandUp