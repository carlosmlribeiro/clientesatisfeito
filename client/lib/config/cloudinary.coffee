$.cloudinary.config
	cloud_name: Meteor.settings?.public.cloudinary.cloud_name || "carlos-lebre-ribeiro-lda"

_cloudinary.after.update (user, file) ->
	if file.percent_uploaded is 100 and not file.uploading
		result = uploaded.findOne {"publicId": file.publicId}
		uploaded.markLinked result._id
		if file.meta.campaignId?
			Meteor.call "save_url", file.meta.campaignId, file.publicId, file.url, (err) ->
				if err
					console.log err
		else
			Meteor.call "save_ug_image", file.meta.promotionId, file.publicId, file.url, (err) ->
				if err
					console.log err
		if $('.new-picture.in')
			$('.new-picture.in').modal('hide')