###
_id: int
title: string
StandUpId: int // references ActionItem._id
isBlocker: boolean
resolved: boolean
addedBy: int // references User._id
resolvedBy: int // references User._id
addedOn: Date
resolvedOn: Date
###

mongoose   = require 'mongoose'
Schema     = mongoose.Schema
collection = 'ActionItem'


ActionItemSchema = new Schema
	title	        : { type: Schema.Types.String }
	standUpId       : { type: Schema.Types.ObjectId, ref: 'StandUp' }
	startTime       : { type: Schema.Types.Date }
	isBlocker       : { type: Schema.Types.Boolean, default: false }
	resolved        : { type: Schema.Types.Boolean, default: false }
	addedBy         : { type: Schema.Types.ObjectId, ref: 'User' }
	resolvedBy      : { type: Schema.Types.ObjectId, ref: 'User' }
	addedOn         : { type: Schema.Types.Date, default: do Date.now }
	resolvedOn      : { type: Schema.Types.Date, default: null }

ActionItemSchema.post 'save', (doc) ->
	@model 'StandUp'
	.findOneAndUpdate { _id: doc.standUpId }, { $addToSet: { actionItems: doc._id } }, (e, standup) ->
		console.log "POST SAVE"
		console.log standup
		console.log e if e

mongoose.model collection, ActionItemSchema

module.exports = mongoose.model collection