'use strict'

var d_config = require('../dist/config/durations');
var Duration = require('../dist/models/durations');

exports.up = function(next) {
	d_config.minutes.forEach(function(duration) {
		var d = new Duration({
			minutes: duration
		});

		d.save(function(e, _duration) {
			if (e) {
				console.error(e);
			}
		});
	});
  next();
};

exports.down = function(next) {
  next();
};