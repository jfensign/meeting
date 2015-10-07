class DbConfig
	constructor: (endpoint = 'mongodb://localhost/dev') ->
		@endpoint = endpoint

module.exports = new DbConfig process.env.MONGODB_ENDPOINT