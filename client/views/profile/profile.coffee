Template.profile.events
	'click #newsletter': (e, tmpl) ->
		Meteor.users.update Meteor.userId(), {$set: {'profile.newsletter': $(e.target).is(':checked')}}

	'click #newsletterSpecial': (e, tmpl) ->
		Meteor.users.update Meteor.userId(), {$set: {'profile.newsletterSpecial': $(e.target).is(':checked')}}

	'click #apagarContaButton': (e, tmpl) ->
		if not $('#apagarContaCheck').is(':checked')
			throwError 'Para apagar a conta tem que confirmar que não quer que os seus clientes sejam clientes satisfeitos', "danger"
		else
			Meteor.call "deleteUser", Meteor.userId()

	'blur #profileName': () ->
		Meteor.users.update Meteor.userId(), {$set: {'profile.name': $('#profileName').html()}}

	'blur #profileEmail': () ->
		Meteor.users.update Meteor.userId(), {$set: {'profile.email': $('#profileEmail').html()}}

	'focus #profileEmail': () ->
        $('#profileEmail').data 'before', $('#profileEmail').text()