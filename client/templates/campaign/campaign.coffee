Template.campaign.helpers
	isOwner: () ->
		Meteor.user()?.profile?.activeAccount?.id is @accountId and Meteor.user()?.profile?.admin