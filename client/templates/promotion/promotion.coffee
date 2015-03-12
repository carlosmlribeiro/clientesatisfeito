Template.promotion.helpers
	isOwner: () ->
		@promotion?.ownedBy is Meteor.userId()

	isExpired: () ->
		@promotion.status is "shared" or @promotion.status is "complain"

Template.promotion.events
	'click #login': (e, tmpl) ->
		if ga?
			ga('send','event','login','promotionlogin')
		login()

	'click #customer-mode': (e,tmpl) ->
		Meteor.users.update(Meteor.userId(), {$set: {'profile.admin': false}})

	'click #claim': (e, tmpl) ->
		Meteor.call "claimPromotion", @promotionId, @campaign._id