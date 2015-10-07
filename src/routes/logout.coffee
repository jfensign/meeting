class Logout
	constructor: (router, resource) ->
		@router   = router
		@resource = resource 

		@router.post "/", post
		@router.get "/",  get

	post = (req, res) ->
		console.log "%s: %s", req.method.toUpperCase(), req.url

	get = (req, res) ->
		console.log "%s: %s", req.method.toUpperCase(), req.url
		res.json({success: true})

	get_routes: ->
		@router

module.exports = Logout