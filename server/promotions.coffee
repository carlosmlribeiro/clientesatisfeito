Meteor.methods
	createPromotionEmail: (campaignId, email, offerDesc) -> 
		user = Meteor.user()

		# ensure the user is logged in
		if not user
			throw new Meteor.Error 401, "Por favor inicie a sessão!"

		if not user.profile?.activeAccount?.id or not user.profile?.admin
			throw new Meteor.Error 401, "Tem que ser vendedor para criar uma promoção!"

		account =
			"id": user.profile.activeAccount.id
			"name": user.profile.activeAccount.name
		
		promotion =
			"createdBy": user._id
			"account": account
			"created": new Date()
			"email": email
			"campaignId": campaignId
			"status": "created"
			"ownedBy": false
			"hash": Random.hexString(6).toUpperCase()

		promotionId = Promotion.insert promotion

		promotionURL = Meteor.absoluteUrl() + 'campaign/' + campaignId + '/promotion/' + promotionId

		if email isnt ""
			@unblock
			#send email
			Meteor.call 'sendEmail', "", email, 'promotionInvite', '', "Foi convidado para ser um Cliente Satisfeito", {url: promotionURL, accountName: user.profile.activeAccount.name, offerDesc: offerDesc}, user.profile.activeAccount.name + " convidou-o para ser um Cliente Satisfeito\n\nQueremos agradecer-lhe ser nosso Cliente e gostariamos de contar consigo para ser um embaixador da nossa marca.\n\nAceite a nossa oferta de " + offerDesc + " partilhando a sua experiência no seu Facebook.\n\nReclame a oferta seguindo este link: " + encodeURIComponent(promotionURL) + "\n\nEste link dá acesso à aplicação Cliente Satisfeito. Após login via Facebook poderá reclamar a oferta.\n\nNão se esqueçam de gostar da nossa página no Facebook para estarem a par das novidades: http://facebook.com/clientesatisfeito.pt", (err, result) ->
				if err
					console.log err

		result =
			id: promotionId
			email: email
			status: "created"
			created: promotion.created
			hash: promotion.hash
			promotionURL: promotionURL

	claimPromotion: (promotionId, campaignId) -> 
		Promotion.update promotionId, {$set: {'ownedBy': Meteor.userId(), 'status': 'claimed', 'ownedByName': Meteor.user().profile.name}}
		Campaign.update {"_id": campaignId, "promotions.id": promotionId}, {$set: {'promotions.$.status': 'claimed', 'promotions.$.claimedDate': new Date(), 'promotions.$.name': Meteor.user().profile.name}, $inc: {'claims': 1}}
		#add customer

	sharePromotion: (campaignId, promotionId, message, image) -> 

		campaignURL = Meteor.absoluteUrl() + 'campaign/' + campaignId

		image = image.replace /upload/, "upload/t_watermark"

		try
			result = Meteor.call "sharePromotionOnFacebook", campaignURL, message, image
			if result
				Promotion.update promotionId, {$set: {'shareId': result, 'status': 'shared'}}
				Campaign.update {"_id": campaignId, "promotions.id": promotionId}, {$set: {'promotions.$.status': 'shared', 'promotions.$.sharedDate': new Date()}, $inc: {'shares': 1}}
		catch e
			throw e

	addComplain: (campaignId, promotionId, accountId, message) -> 

		messageObj = 
			message: message
			type: "complain"
			userId: Meteor.userId()
			campaign: campaignId
			promotion: promotionId
			created: new Date()

		Promotion.update promotionId, {$set: {'status': 'complain'}}
		Campaign.update {"_id": campaignId, "promotions.id": promotionId}, {$set: {'promotions.$.status': 'complain', 'promotions.$.complainDate': new Date()}, $inc: {'complains': 1}}
		Account.update {"_id": accountId}, {$push: {'messages': messageObj}}


