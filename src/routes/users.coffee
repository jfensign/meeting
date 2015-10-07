class Users
	constructor: (router, resource) ->
		@router   = router
		@resource = resource

	get_routes: ->
		@router

module.exports = Users