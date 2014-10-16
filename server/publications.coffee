Meteor.publish "userData", () ->
    Meteor.users.find {_id: @userId},
        {fields: {'accounts': 1}}

Meteor.publish "singlePromotion", (promotionId) ->
	Promotion.find {_id: promotionId}