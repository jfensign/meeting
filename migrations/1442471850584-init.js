'use strict'

var mongoose = require('mongoose');
var config   = require('../dist/config');
var models   = require('../dist/models');

mongoose.connect(config.db.endpoint)

exports.up = function(next) {
  var user_seeds = [
  	{ intranetId: 123, avatar: null, name: 'John Doe' },
  	{ intranetId: 123, avatar: null, name: 'Jane Doe' },
  	{ intranetId: 123, avatar: null, name: 'John Smith' }
  ]

  user_seeds.forEach(function(seed) {
  	var user = new models.users(seed);
  	user.save();
  });

  next();
};

exports.down = function(next) {
  next();
};
