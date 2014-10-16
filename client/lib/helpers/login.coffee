@login = () ->
	clearErrors()
	Meteor.loginWithFacebook
		requestPermissions: ['manage_pages','email','offline_access','publish_actions','read_stream']
		(err) ->
			if err
				throwError err.reason, "danger"
			else
				if Meteor.user().profile.admin
					Router.go '/profile'
				else	
					Router.go '/home'

@adminMode = () ->
	Meteor.call 'getPages', (err) ->
		if err
			throwError err.message, err.details