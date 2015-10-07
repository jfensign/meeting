###
_id: int
userId: int // references User._id
standUpId: int // references StandUp._id, the combination (userId, standUpId) should be unique
###

mongoose   = require 'mongoose'
Schema     = mongoose.Schema
collection = 'Notification' 

NotificationSchema = new Schema
	title	        : { type: Schema.Types.String }
	userId          : { type: Schema.Types.ObjectId, ref: 'User' }
	StandUpId       : { type: Schema.Types.ObjectId, ref: 'StandUp', default: null }

NotificationSchema.index { userId: 1, standUpId: 1 }, { unique: true }

Notification = mongoose.model collection, NotificationSchema

module.exports = Notification