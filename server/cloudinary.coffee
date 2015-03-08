Meteor.methods
	save_url: (campaignId, newPublicId, newUrl) ->
		campaign = Campaign.findOne {"_id": campaignId}
		oldImage = campaign.imageId
		if oldImage
			Meteor.call "cloudinary_delete", oldImage, (err, result) ->
				if err
					console.log err
		Campaign.update {"_id": campaignId}, {"$set": {"imageId": newPublicId, "imageURL": newUrl}}

	save_ug_image: (promotionId, newPublicId, newUrl) ->
		promotion = Promotion.findOne {"_id": promotionId}
		oldImage = promotion.imageId
		if oldImage
			Meteor.call "cloudinary_delete", oldImage, (err, result) ->
				if err
					console.log err
		Promotion.update {"_id": promotionId}, {"$set": {"imageId": newPublicId, "imageURL": newUrl}}