Template.campaignItem.events
	'click #campaignDetail': (e, tmpl) ->
		Router.go '/campaign/'+@_id

	'click #createCampaignQR': (e, tmpl) ->
		$('#qrCode').html ""
		campaignId = @_id
		Meteor.call "createPromotionEmail", campaignId, "", "", (err, result) ->
			if err
				console.log err
			if result
				#update campaign
				Campaign.update campaignId, {$push: {'promotions': result}}
				promotionCreated = true
				$('#qrCode').qrcode {text: result.promotionURL}
				$('#qrModalConfirmation').modal
					backdrop: 'static'
					keyboard: false

Template.campaignItem.helpers
	myProgress: (progress) ->
		Math.round((progress?.loaded? * 100.0) / progress?.total?)