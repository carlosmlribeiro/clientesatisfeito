Template.appDashboard.helpers
	account: () ->
		Account.find()
	user: () ->
		Meteor.users.find()
	isPending: (status) ->
		status is 'pending'

Template.appDashboard.events
	'click .activate': (e, tmpl) ->
		accountId = $(e.target).attr('id')
		Meteor.call "setToActive", accountId, (err, result) ->
			if err
				throwError 'Não foi possível ativar a conta!', "danger"