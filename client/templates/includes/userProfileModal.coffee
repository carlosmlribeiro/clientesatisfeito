Template.userProfileModal.events
	'click #admin-mode-cs': (e,tmpl) ->	
		adminMode()
		$('#ProfileModal').modal('hide')

	'click #newsletter-cs': (e, tmpl) ->
		Meteor.users.update Meteor.userId(), {$set: {'profile.newsletter': $(e.target).is(':checked')}}

	'blur #profileName': () ->
		Meteor.users.update Meteor.userId(), {$set: {'profile.name': $('#profileName').html()}}

	'blur #profileEmail': () ->
		Meteor.users.update Meteor.userId(), {$set: {'profile.email': $('#profileEmail').html()}}

	'focus #profileEmail': () ->
        $('#profileEmail').data 'before', $('#profileEmail').text()