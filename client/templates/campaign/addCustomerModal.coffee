Template.addCustomerModal.events
	'click .addCustomerBtn': (e, tmpl) ->
		e.preventDefault()
		campaignId = @_id
		offerDesc = @description
		customerEmail = $('#addCustomer'+@_id).val()
		$('#addCustomerBtn'+campaignId).text('A adicionar...')
		$('#addCustomerBtn'+campaignId).attr('disabled','disabled');
		if customerEmail isnt "" 
			if _.findWhere @promotions, {email: customerEmail}
				$('#customerNameGroup'+campaignId).addClass("has-error")
				$('#helpBlock'+campaignId).text("Este cliente já foi adicionado à oferta")
				$('#addCustomerBtn'+campaignId).text 'OK'
				$('#addCustomerBtn'+campaignId).removeAttr 'disabled'
			else
				Meteor.call "validateEmailClient", customerEmail, (err, result) ->
					if result
						$('#newCustomer'+campaignId).modal('hide')
						#upsert customer
						Meteor.call "createPromotionEmail", campaignId, customerEmail, offerDesc, (err, result) ->
							if err
								$('#customerNameGroup'+campaignId).addClass("has-error")
								$('#helpBlock'+campaignId).text(err.message)
								$('#addCustomerBtn'+campaignId).text 'OK'
								$('#addCustomerBtn'+campaignId).removeAttr 'disabled'
							if result
								#update campaign
								Campaign.update campaignId, {$push: {'promotions': result}}
								promotionCreated = true
					else
						$('#customerNameGroup'+campaignId).addClass("has-error")
						$('#helpBlock'+campaignId).text("Por favor corrija o email do cliente")
						$('#addCustomerBtn'+campaignId).text 'OK'
						$('#addCustomerBtn'+campaignId).removeAttr 'disabled'	
		else
			$('#customerNameGroup'+@_id).addClass("has-error")
			$('#helpBlock'+@_id).text("Por favor preencha o email do cliente")
			$('#addCustomerBtn'+campaignId).text 'OK'
			$('#addCustomerBtn'+campaignId).removeAttr 'disabled'

	'focus .addCustomer': (e) ->
		$('#customerNameGroup'+@_id).removeClass("has-error")
		$('#helpBlock'+@_id).text("O cliente será informado por email para a sua participação na campanha")

	'shown.bs.modal .newCustomer': (e) ->
		$('#addCustomer'+@_id).focus()

	'hidden.bs.modal .newCustomer': (e) ->
		$('#customerNameGroup'+@_id).removeClass("has-error")
		$('#helpBlock'+@_id).text("O cliente será informado por email para a sua participação na campanha")
		$('#addCustomer'+@_id).val("")
		$('#addCustomerBtn'+@_id).text 'OK'
		$('#addCustomerBtn'+@_id).removeAttr 'disabled'	