Router.configure
	layoutTemplate: 'layout'
	loadingTemplate: 'loading'
	notFoundTemplate: 'notFound'
	trackPageView: true

Router.map ->
	@route 'index',
		path: '/'

	@route 'home'

	@route 'profile',
		waitOn: ->
			Meteor.subscribe 'userData'

	@route 'appDashboard',
		waitOn: ->
			[Meteor.subscribe('allAccounts'), Meteor.subscribe('allUsers')]

	@route 'campaignList',
		path: '/campaign',
		waitOn: ->
			if Meteor.user() && Meteor.user().profile.admin
				Meteor.subscribe 'myCampaigns', Meteor.user().profile.activeAccount.id

	@route 'campaign',
		path: '/campaign/:_id',
		waitOn: ->
			Meteor.subscribe "campaign", @params._id,

		data: ->
			Campaign.findOne @params._id,

		onBeforeAction: ->
			campaign = Campaign.findOne @params._id
			url = Meteor.absoluteUrl() + "campaign/" + @params._id 
			appid = Meteor.settings?.public.facebook?.appid || "444633195674920"
			ns = Meteor.settings?.public.facebook?.ns || "clientesatisfeito-l"
			ogtype = ns + ':' + campaign.type
			if campaign.imageId
				image = campaign.imageURL
			else
				image = "http://cdn.clientesatisfeito.pt/img/logo140.jpg"

			#set Facebook meta data for the open graph object
			$("meta[property='fb:app_id']").attr "content", appid
			$("meta[property='og:type']").attr "content", ogtype
			$("meta[property='og:url']").attr "content", url
			$("meta[property='og:title']").attr "content", campaign.name
			$("meta[property='og:description']").attr "content", campaign.description
			$("meta[property='og:image']").attr "content", image
			$("meta[property='account']").attr "property", ns + ':account'
			$("meta[property='" + ns + ":account']").attr "content", campaign.accountId

			@next()

	@route 'promotion',
		path: '/campaign/:campaignId/promotion/:_id',
		waitOn: ->
			[Meteor.subscribe("promotion", @params._id, Meteor.userId()), Meteor.subscribe("promotionOwner", @params._id), Meteor.subscribe("campaign", @params.campaignId)]
		data: ->
			campaign: Campaign.findOne @params.campaignId
			promotion: Promotion.findOne @params._id
			promotionId: @params._id


	#add route for mailgun to update newsletter value
	@route 'mailgun',
		path: '/api/unsubscribe'
		where: 'server'
		action: () ->
			result = Meteor.call 'unsubscribeUser', @request.body
			
			if result
				@response.statusCode = 200
				@response.end()
				

requireLogin = () ->
	if !Meteor.user()
		if Meteor.loggingIn()
			@render @loadingTemplate
		else
			Router.go '/'
	else
		if Meteor.user().profile.admin is true
			Router.go '/profile'
		else
			@next()

requireAdmin = () ->
	if !Meteor.user()
		if Meteor.loggingIn()
			@render @loadingTemplate
		else
			Router.go '/'
	else
		if !Meteor.user().profile.admin is true
			Router.go '/home'
		else
			@next()

requireSuperAdmin = () ->
	if !Meteor.user()
		if Meteor.loggingIn()
			@render @loadingTemplate
		else
			Router.go '/'
	else
		if !Meteor.user().profile.admin is true
			Router.go '/home'
		else
			if Meteor.user().profile.activeAccount?.id is "550434438435613" 
				@next()
			else
				Router.go '/profile'

requireUnknown = () ->
	if Meteor.user()
		if Meteor.user().profile.admin is true
			Router.go '/profile'
		else
			Router.go '/home'
	else
		if Meteor.loggingIn()
			@render @loadingTemplate
		else
			@next()

Router.onBeforeAction () ->
	if @params.query?.ref
		d = new Date
		d.setTime(d.getTime() + (1*24*60*60*1000));
		expires = "expires="+d.toUTCString();
		document.cookie = "ref=" + @params.query.ref + "; " + expires
	@next()

Router.onBeforeAction 'dataNotFound', 
	only: ['campaign', 'promotion']
Router.onBeforeAction 'loading',
	except: 'mailgun'
Router.onBeforeAction requireLogin, 
	only: 'home'
Router.onBeforeAction requireAdmin,
	only: ['profile', 'campaignList']
Router.onBeforeAction requireUnknown,
	only: 'index'
Router.onBeforeAction requireSuperAdmin,
	only: 'appDashboard'
Router.onBeforeAction () ->
	if Meteor.isClient
		clearErrors()
		$('body').scrollTop 0
	@next()