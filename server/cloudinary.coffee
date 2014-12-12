Meteor.methods
	save_url: (response) ->
		Campaign.update {"_id": response.context._id}, {"$set": {"imageId": response.upload_data.public_id, "imageURL": response.upload_data.url}}

	save_ug_image: (response) ->
		Promotion.update {"_id": response.context.promotion._id}, {"$set": {"imageId": response.upload_data.public_id, "imageURL": response.upload_data.url}}