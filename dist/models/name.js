// Generated by CoffeeScript 1.10.0

/*
_id: int
name: string // unique
 */

(function() {
  var NameSchema, Schema, collection, mongoose;

  mongoose = require('mongoose');

  Schema = mongoose.Schema;

  collection = 'Name';

  NameSchema = new Schema({
    name: {
      type: Schema.Types.String
    }
  });

  mongoose.model(collection, NameSchema);

  module.exports = mongoose.model(collection);

}).call(this);
