UI.registerHelper 'showSideNav', () ->
	if Router.current().route.getName() in ['profile']
		return true
	else
		return false