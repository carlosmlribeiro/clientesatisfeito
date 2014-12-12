Meteor.methods
	createPromotionEmail: (campaignId, email) -> 
		user = Meteor.user()

		# ensure the user is logged in
		if not user
			throw new Meteor.Error 401, "Por favor inicie a sessão!"

		if not user.profile?.activeAccount?.id or not user.profile?.admin
			throw new Meteor.Error 401, "Tem que ser vendedor para criar uma promoção!"

		promotion =
			"createdBy": user._id
			"accountId": user.profile.activeAccount.id
			"created": new Date()
			"email": email
			"campaignId": campaignId
			"status": "created"
			"ownedBy": false

		promotionId = Promotion.insert promotion

		promotionURL = Meteor.absoluteUrl() + 'campaign/' + campaignId + '/promotion/' + promotionId

		@unblock
		#send email
		Meteor.call 'sendEmail', "", email, 'promotionInvite', '', "Foi convidado para ser um Cliente Satisfeito", {url: promotionURL, accountName: user.profile.activeAccount.name}, "Foi convidado por " + user.profile.activeAccount.name + "para ser um cliente satisfeito e, com isso, obter uma oferta\n\nVisite " + encodeURIComponent(promotionURL), (err, result) ->
			if err
				console.log err

		result =
			id: promotionId
			email: email
			status: "created"
			created: promotion.created

	claimPromotion: (promotionId, campaignId) -> 
		Promotion.update promotionId, {$set: {'ownedBy': Meteor.userId(), 'status': 'claimed'}}
		Campaign.update {"_id": campaignId, "promotions.id": promotionId}, {$set: {'promotions.$.status': 'claimed', 'promotions.$.claimedDate': new Date()}}
		#add customer

	sharePromotion: (campaignId, promotionId, message, image) -> 

		campaignURL = Meteor.absoluteUrl() + 'campaign/' + campaignId

		image = image.replace /upload/, "upload/t_watermark"

		try
			result = Meteor.call "sharePromotionOnFacebook", campaignURL, message, image
			if result
				Promotion.update promotionId, {$set: {'shareId': result, 'status': 'shared'}}
				Campaign.update {"_id": campaignId, "promotions.id": promotionId}, {$set: {'promotions.$.status': 'shared', 'promotions.$.sharedDate': new Date()}}
		catch e
			throw e


