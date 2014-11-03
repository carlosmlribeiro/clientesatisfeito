Template.layout.helpers
	showComingSoon: () ->
		if Router.current().route.getName() in ['profile', 'promotion/:_id']
			return false
		else
			return true

Template.layout.events
	'click #navbrand': (e,tmpl) ->
		e.preventDefault()
		$('body').animate
			scrollTop: 0
			, 400
	