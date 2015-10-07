class AuthConfig
	constructor: (auth_endpoint = 'https://token-service.mybluemix.net/api/token-service/auth', secret = 'dev-secret', client_id = 'client1') ->
		@endpoint  = auth_endpoint
		@secret    = secret
		@client_id = client_id

module.exports = new AuthConfig process.env.AUTH_ENDPOINT, process.env.AUTH_CLIENT_SECRET, process.env.AUTH_CLIENT_ID