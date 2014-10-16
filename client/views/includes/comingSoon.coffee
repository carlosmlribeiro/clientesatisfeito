Template.comingSoon.events
	'click #admin-mode-cs': (e,tmpl) ->	
		adminMode()

	'click #newsletter-cs': (e, tmpl) ->
		Meteor.users.update Meteor.userId(), {$set: {'profile.newsletter': $(e.target).is(':checked')}}