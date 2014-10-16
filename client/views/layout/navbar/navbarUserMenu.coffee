Template.navbarUserMenu.events
	'click #logout': (e,tmpl) ->
		clearErrors()
		Meteor.logout (err)->
			if err
				throwError err.reason, "danger"
			else
				Router.go '/'

	'click #admin-mode': (e,tmpl) ->
		adminMode()

	'click #customer-mode': (e,tmpl) ->
		Meteor.users.update(Meteor.userId(), {$set: {'profile.admin': false}})

	'click #bootstrap-tour': (e,tmpl) ->
		@startTour()