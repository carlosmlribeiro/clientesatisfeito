Meteor.methods
	shareOnFacebook: (accountId, access_token, activationURL) ->
		accessToken = access_token

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