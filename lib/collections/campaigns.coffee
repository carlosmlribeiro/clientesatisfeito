@Campaign = new Mongo.Collection 'campaigns'

Campaign.allow
	'insert': (userId, campaign) ->
		campaign.accountId is Meteor.user().profile.activeAccount?.id
		campaign.created = new Date()
		campaign

	'update': (userId, campaign) ->
		campaign.accountId is Meteor.user().profile.activeAccount?.id			