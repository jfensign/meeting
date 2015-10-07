###
_id: int
name: string // unique
###


mongoose   = require 'mongoose'
Schema 	   = mongoose.Schema
collection = 'Name'

NameSchema = new Schema
	name   : { type: Schema.Types.String }

mongoose.model collection, NameSchema

module.exports = mongoose.model collection