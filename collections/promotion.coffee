@Promotion = new Meteor.Collection 'promotions'

Meteor.methods
  createPromotion: (promotion) -> 
    user = Meteor.user()

    # ensure the user is logged in
    if not user
      throw new Meteor.Error 401, "You need to login"

    promotion.user = user._id

    promotionId = Promotion.insert promotion

    promotionId
    

