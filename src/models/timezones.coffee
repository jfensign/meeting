mongoose   = require 'mongoose'
Schema     = mongoose.Schema
collection = 'TimeZone'


TimeZoneSchema = new Schema
	name		: { type: Schema.Types.String, unique: true, required: true }

TimeZone = mongoose.model collection, TimeZoneSchema

module.exports = TimeZone