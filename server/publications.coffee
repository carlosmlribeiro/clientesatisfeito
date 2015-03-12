Meteor.publish "userData", () ->
    Meteor.users.find {_id: @userId},
        {fields: {'accounts': 1}}

Meteor.publish "promotion", (promotionId, userId) ->
	Promotion.find {_id: promotionId, ownedBy: userId}

Meteor.publish "promotionOwner", (promotionId) ->
	Promotion.find {_id: promotionId},
        {fields: {'ownedBy': 1, 'account': 1}}

Meteor.publish "allAccounts", () ->
	Account.find {}
	
Meteor.publish "allUsers", () ->
	Meteor.users.find {}
	
Meteor.publish "myCampaigns", (id) ->
	Campaign.find {accountId: id}, {sort: {created: -1}}

Meteor.publish "campaign", (id) ->
	Campaign.find {_id: id}

Meteor.publish "publicCampaigns", () ->
	Campaign.find {public: 'on'}