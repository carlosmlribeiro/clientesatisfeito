UI.registerHelper 'showSideNav', () ->
	if Router.current().route.name in ['profile']
		return true
	else
		return false