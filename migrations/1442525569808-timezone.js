'use strict'

var TimeZone = require('../dist/models/timezones');

exports.up = function(next) {
	["PDT", "EST", "GMT", "CST"].forEach(function(tz) {
		var timezone = new TimeZone({
			name: tz
		});

		console.log(timezone)

		timezone.save();
	});

  next();
};

exports.down = function(next) {
  next();
};
