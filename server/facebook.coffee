facebookNS = process.env.FACEBOOK_NS || Meteor.settings.FACEBOOK_NS

Meteor.methods
	shareOnFacebook: (accountId, access_token, activationURL) ->

		@unblock

		try
			result = Meteor.http.post "https://graph.facebook.com/v2.1/" + accountId + "/feed",
			params:
				access_token: access_token
				link: activationURL
				message: 'Por um Portugal cheio de clientes satisfeitos! Registem-se também na aplicação @[550434438435613].'
				picture: 'http://cdn.clientesatisfeito.pt/img/logo.jpg'
				caption: 'O melhor vendedor é um cliente satisfeito'
				description: 'Gestão de promoções e clientes. Façam dos vossos clientes, clientes satisfeitos!'
		catch e
			throw new Meteor.Error e.response.statusCode, e.response.data.error.message, "danger"

		Account.update {"_id": accountId}, {"$push": {"posts": result.data.id}}

		true

	sharePromotionOnFacebook: (campaignURL, message, image) ->
		@unblock

		if image
			params = 
				'image[0][url]': image
				'image[0][user_generated]': true

		if message
			params.message = message

		params.access_token = Meteor.user().services.facebook.accessToken
		params.offer = campaignURL #"http://samples.ogp.me/476432209161685"

		try
			result = Meteor.http.post "https://graph.facebook.com/v2.1/" + Meteor.user().profile.fbid + "/" + facebookNS + ":subscribe",
			params: params
		catch e
			throw new Meteor.Error e.response.statusCode, e.response.data.error.message, "danger"

		result.data.id

	confirmPromotion: (postId, userToken) ->
		@unblock

		try
			result = Meteor.http.get "https://graph.facebook.com/v2.1/" + postId,
			params:
				access_token: userToken
		catch e
			throw new Meteor.Error e.response.statusCode, e.response.data.error.message, "danger"

		result.data.id?