ServiceConfiguration.configurations.remove
	service: "facebook"

ServiceConfiguration.configurations.insert
	service: "facebook"
	appId: process.env.FACEBOOK_APP_ID || Meteor.settings.FACEBOOK_APP_ID
	secret: process.env.FACEBOOK_APP_SECRET || Meteor.settings.FACEBOOK_APP_SECRET

Meteor.methods
	getFBappid: () ->
		result = {}
			
		result.appid = process.env.FACEBOOK_APP_ID || Meteor.settings.FACEBOOK_APP_ID

		if result.appid is '444632665674973'
			result.ns = 'clientesatisfeito-d'
		else
			result.ns = 'clientesatisfeito'
		
		result