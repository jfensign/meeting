class DurationsConfig
	constructor: (_minutes = "15, 30, 45, 60, 90, 120") ->
		@minutes = _minutes.split ","
		.map (duration) -> 
			~~duration.trim()

module.exports = new DurationsConfig process.env.DURATIONS