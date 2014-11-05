Template.sidenav.events
	'click .disabled': (e) ->
		e.preventDefault()

Template.sidenav.helpers
	activeRouteClass: () ->
		args = Array.prototype.slice.call(arguments, 0)
		args.pop()

		active = _.any args, (name) -> 
			return Router.current() && Router.current().route.getName() is name

		return active && 'active'