Template.layout.helpers
	showComingSoon: () ->
		if Router.current().route.getName() in ['profile', 'promotion', 'appDashboard', 'campaign', 'campaignList']
			return false
		else
			return true