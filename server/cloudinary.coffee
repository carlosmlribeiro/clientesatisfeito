Meteor.methods
	save_url: (response) ->
		oldImage = response.context.imageId
		if oldImage
			Meteor.call "cloudinary_delete", oldImage, (err, result) ->
				if err
					console.log err
		Campaign.update {"_id": response.context._id}, {"$set": {"imageId": response.upload_data.public_id, "imageURL": response.upload_data.url}}

	save_ug_image: (response) ->
		oldImage = response.context.promotion.imageId
		if oldImage
			Meteor.call "cloudinary_delete", oldImage, (err, result) ->
				if err
					console.log err
		Promotion.update {"_id": response.context.promotion._id}, {"$set": {"imageId": response.upload_data.public_id, "imageURL": response.upload_data.url}}