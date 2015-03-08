Template.navbarUserMenu.helpers
	isActiveAccount: (id) ->
		id is Meteor.user().profile.activeAccount.id && Meteor.user().profile.admin

	isInactive: (status) ->
		status is 'inactive'

	getClass: (status) ->
		if status is 'pending'
			'disabled'

	hasAccounts: (accounts) ->
		if accounts
			accounts.length > 0

Template.navbarUserMenu.events
	'click #logout': (e,tmpl) ->
		clearErrors()
		Meteor.logout (err)->
			if err
				throwError err.reason, "danger"

	'click .admin-mode': (e,tmpl) ->
		adminMode()

	'click .set-admin': (e,tmpl) ->
		if $(e.target).attr('disabled') is 'disabled'
			e.preventDefault()
		else
			Meteor.users.update(Meteor.userId(), {$set: {'profile.admin': true, 'profile.activeAccount': {'id': $(e.target).attr('pageid'), 'name': $(e.target).attr('name')}}})

	'click #customer-mode': (e,tmpl) ->
		Meteor.users.update(Meteor.userId(), {$set: {'profile.admin': false}})

	'click #bootstrap-tour': (e,tmpl) ->
		@startTour()