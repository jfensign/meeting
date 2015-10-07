###
_id: int
standUpId: int // references StandUp._id
userId: int // references User._id
mood: int // a value between 0 - 4 (inclusive)
date: Date
###

max = [4, 'The value of `{PATH}` ({VALUE}) exceeds the limit ({MAX}).']
min = [0, 'The value of `{PATH}` ({VALUE}) exceeds the limit ({MAX})']

mongoose   = require 'mongoose'
Schema     = mongoose.Schema
collection = 'Mood'

MoodSchema = new Schema
	standUpId: { type: Schema.Types.ObjectId, ref: 'StandUp', required: true }
	userId   : { type: Schema.Types.ObjectId, ref: 'User', required: true }
	mood     : { type: Schema.Types.Number, required: true, min: min, max: max  }
	date     : { type: Schema.Types.Date, default: do Date.now }

Mood = mongoose.model collection, MoodSchema

module.exports = Mood