UI.registerHelper 'showSideNav', () ->
	if Router.current().route.getName() in ['profile','appDashboard','campaign','campaignList'] and Meteor.user()?.profile?.admin
		return true
	else
		return false

UI.registerHelper 'activeRouteClass', () ->
	args = Array.prototype.slice.call(arguments, 0)
	args.pop()

	active = _.any args, (name) ->
		return Router.current() && name.indexOf(Router.current().route.getName()) is 0

	return active && 'active'