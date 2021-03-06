// Generated by CoffeeScript 1.10.0

/*
_id: int
title: string
projectGoals: string
callInNumber: string
timezoneId: int // references Timezone._id
startTime: time // the scheduled time to start the standup, note we only need time, date part is not needed since a standup happens every day at the same time
status: int // status can be “0 - Not Running”, “1 - Running Now”
duration: int // references Duration._id
scrumMaster: int // references User._id
 */

(function() {
  var ActionItem, Notification, Participant, Schema, StandUp, StandUpSchema, User, _, async, collection, mongoose, q;

  mongoose = require('mongoose');

  Schema = mongoose.Schema;

  collection = 'StandUp';

  async = require('async');

  User = require('./users');

  Participant = require('./participants');

  Notification = require('./notifications');

  ActionItem = require('./actionitems');

  _ = require('underscore');

  q = require('q');

  StandUpSchema = new Schema({
    title: {
      type: Schema.Types.String,
      unique: true
    },
    projectGoals: {
      type: Schema.Types.String
    },
    callInNumber: {
      type: Schema.Types.String
    },
    timezoneId: {
      type: Schema.Types.ObjectId,
      ref: 'Timezone'
    },
    startTime: {
      type: Schema.Types.Date
    },
    status: {
      type: Schema.Types.Number,
      "default": 0
    },
    duration: {
      type: Schema.Types.ObjectId,
      ref: 'Duration'
    },
    scrumMaster: {
      type: Schema.Types.ObjectId,
      ref: 'User'
    },
    participants: [
      {
        type: Schema.Types.ObjectId,
        ref: 'Participant'
      }
    ],
    actionItems: [
      {
        type: Schema.Types.ObjectId,
        ref: 'ActionItem'
      }
    ],
    mood: {
      type: Schema.Types.Number,
      "default": null
    }
  });

  StandUpSchema.statics.findAndModify = function(query, sort, doc, options, cb) {
    return this.collection.findAndModify(query, sort, doc, options, cb);
  };

  StandUpSchema.statics.deleteBatch = function(ids, cb) {
    return this.model(collection.find({
      _id: {
        $in: ids
      }
    }).exec(function(e, docs) {
      return async.forEach(docs, function(doc, _cb) {
        doc.remove();
        return _cb();
      }, cb);
    }));
  };

  StandUpSchema.methods.update_mood = function(cb) {
    return this.model('Participant').find({
      standUpId: this._id
    }).exec((function(_this) {
      return function(e, participants) {
        return async.map(participants, function(participant, _cb) {
          return participant.mood(5, function(e, moods) {
            var m;
            moods = (function() {
              var i, len, results;
              results = [];
              for (i = 0, len = moods.length; i < len; i++) {
                m = moods[i];
                results.push(m.mood);
              }
              return results;
            })();
            if (moods.length === 0) {
              moods = [0, 4];
            }
            return _cb(null, moods);
          });
        }, function(e, result) {
          if (e) {
            return cb(e);
          }
          result = _.flatten(result);
          _this.mood = ~~((result.reduce(function(a, b) {
            return a + b;
          })) / result.length);
          return _this.save(cb);
        });
      };
    })(this));
  };

  StandUpSchema.pre('remove', function(next) {
    return async.forEach([Notification, Participant, ActionItem], (function(_this) {
      return function(model, cb) {
        return model.find({
          standUpId: _this._id
        }).remove(cb);
      };
    })(this), next);
  });

  StandUpSchema.pre('save', function(next) {
    var notify_participant, participants, save_participant;
    participants = this.participants = _.uniq(this.participants);
    async.forEach(this.participants, (function(_this) {
      return function(participant, cb) {
        return User.findById(participant, function(e, u_doc) {
          if (e) {
            return cb(e);
          }
          return save_participant(u_doc, participant, cb);
        });
      };
    })(this), (function(_this) {
      return function(e) {
        _this.participants = participants;
        return next();
      };
    })(this));
    notify_participant = (function(_this) {
      return function(p_doc, cb) {
        var notif;
        notif = new Notification(_.pick(p_doc.value, 'standUpId', 'userId'));
        return notif.save(cb);
      };
    })(this);
    return save_participant = (function(_this) {
      return function(user_doc, participant, cb) {
        if (!user_doc) {
          return cb(null, true);
        }
        return Participant.findAndModify({
          userId: user_doc._id,
          standUpId: _this._id
        }, [], {
          userId: user_doc._id,
          standUpId: _this._id,
          order: _this.participants.indexOf(participant)
        }, {
          upsert: true,
          "new": true
        }, function(e, p_doc) {
          if (!e) {
            participants[~~p_doc.value.order] = p_doc.value._id;
          }
          return notify_participant(p_doc, cb);
        });
      };
    })(this);
  });

  StandUp = mongoose.model(collection, StandUpSchema);

  module.exports = StandUp;

}).call(this);
