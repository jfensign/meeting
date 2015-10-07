// Generated by CoffeeScript 1.10.0

/*
userId: int // references User._id
standUpId: int // references StandUp._id, the combination (userId, standUpId) should be unique
isOnline: boolean
doneSpeaking: boolean
order: int
 */

(function() {
  var Participant, ParticipantSchema, Schema, collection, mongoose;

  mongoose = require('mongoose');

  Schema = mongoose.Schema;

  collection = 'Participant';

  ParticipantSchema = new Schema({
    userId: {
      type: Schema.Types.ObjectId,
      ref: 'User'
    },
    standUpId: {
      type: Schema.Types.ObjectId,
      ref: 'StandUp.'
    },
    isOnline: {
      type: Schema.Types.Boolean,
      "default": false
    },
    doneSpeaking: {
      type: Schema.Types.Boolean,
      "default": false
    },
    order: {
      type: Schema.Types.Number,
      "default": 0
    }
  });

  ParticipantSchema.index({
    userId: 1,
    standUpId: 1
  }, {
    unique: true
  });

  ParticipantSchema.methods.mood = function(days, cb) {
    var days_ago;
    days_ago = days ? Date.now() - (days * (24 * 60 * 60)) : null;
    return this.model('Mood').find({
      userId: this.userId
    }).select("mood").exec(cb);
  };

  ParticipantSchema.statics.findAndModify = function(query, sort, doc, options, cb) {
    return this.collection.findAndModify(query, sort, doc, options, cb);
  };

  Participant = mongoose.model(collection, ParticipantSchema);

  module.exports = Participant;

}).call(this);