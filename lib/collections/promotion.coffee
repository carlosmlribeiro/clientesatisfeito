@Promotion = new Mongo.Collection 'promotions'

Promotion.allow
	'update': (userId, promotion) ->
		true