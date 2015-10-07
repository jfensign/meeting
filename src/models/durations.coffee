###
_id: int
minutes: int // time in minutes, unique
###

mongoose   = require 'mongoose'
d_config     = require '../config/durations'
schema 	   = mongoose.Schema
collection = 'Duration'

DurationSchema = new schema
	minutes: { type: schema.Types.Number, require: true, unique: true }

Duration = mongoose.model collection, DurationSchema

Duration.schema.path 'minutes'
.validate (value) ->
	!!~d_config.minutes.indexOf ~~value

module.exports = Duration