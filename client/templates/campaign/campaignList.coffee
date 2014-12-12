campaign = {}
campaignCreated = false

Template.campaignList.helpers
	campaign: () ->
		Campaign.find()

Template.campaignList.events
	'click #createCampaign': (e, tmpl) ->
		e.preventDefault()
		campaignName = $('#campaignName').val()
		if campaignName isnt ""
			$('#newCampaign').modal('hide')
			campaign =
				name: campaignName,
				accountId: Meteor.user().profile.activeAccount.id,
				description: $('#campaignDescription').val(),
				type: "offer"
				promotions: []
			campaign._id = Campaign.insert campaign
			campaignCreated = true
		else
			$('#campaignNameGroup').addClass("has-error")
			$('#helpBlock').text("Por favor preencha o nome da campanha")

	'hidden.bs.modal #newCampaign': (e) ->
		$('#campaignNameGroup').removeClass("has-error")
		$('#helpBlock').text("")
		$('#campaignName').val("")
		if campaignCreated
			campaignCreated = false

	'shown.bs.modal #newCampaign': (e) ->
		$('#campaignName').focus()

	'focus #campaignName': (e) ->
		$('#campaignNameGroup').removeClass("has-error")
		$('#helpBlock').text("")