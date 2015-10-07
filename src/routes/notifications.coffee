class Notification
	constructor: (router, resource) ->
		@router   = router
		@resource = resource 

		@router.post "/", post
		@router.get "/",  get

	post = (req, res) ->
		console.log "%s: %s", req.method.toUpperCase(), req.url

	get = (req, res) ->
		console.log "%s: %s", req.method.toUpperCase(), req.url

	get_routes: ->
		@router

module.exports = Notification