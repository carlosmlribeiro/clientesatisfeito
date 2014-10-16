Router.configure
	layoutTemplate: 'layout'
	loadingTemplate: 'loading'
	notFoundTemplate: 'notFound'

Router.map ->
	@route 'index',
		path: '/'

	@route 'home'

	@route 'profile',
		waitOn: ->
			Meteor.subscribe 'userData'

	#add route for mailgun to update newsletter value
	@route 'mailgun',
		path: '/api/unsubscribe'
		where: 'server'
		action: () ->
			result = Meteor.call 'unsubscribeUser', @request.body
			
			if result
				@response.statusCode = 200
				@response.end()
				

requireLogin = (pause) ->
	if !Meteor.user()
		if Meteor.loggingIn()
			@render @loadingTemplate
			pause()
		else
			Router.go '/'
	else
		if Meteor.user().profile.admin is true
			Router.go '/profile'

requireAdmin = (pause) ->
	if !Meteor.user()
		if Meteor.loggingIn()
			@render @loadingTemplate
			pause()
		else
			Router.go '/'
	else
		if !Meteor.user().profile.admin is true
			Router.go '/home'

requireUnknown = (pause) ->
	if Meteor.user()
		if Meteor.user().profile.admin is true
			Router.go '/profile'
		else
			Router.go '/home'
	else
		if Meteor.loggingIn()
			@render @loadingTemplate
			pause()

Router.onBeforeAction () ->
	if @params.ref
		d = new Date
		d.setTime(d.getTime() + (1*24*60*60*1000));
		expires = "expires="+d.toUTCString();
		document.cookie = "ref=" + @params.ref + "; " + expires
Router.onBeforeAction 'loading',
	except: 'mailgun'
Router.onBeforeAction requireLogin, 
	only: 'home'
Router.onBeforeAction requireAdmin,
	only: 'profile'
Router.onBeforeAction requireUnknown,
	only: 'index'
Router.onBeforeAction () ->
	if Meteor.isClient
		clearErrors()

Router.onRun ()->
	if Meteor.isClient
		$('body').animate
			scrollTop: 0
			, 0