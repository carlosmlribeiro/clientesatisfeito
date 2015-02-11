Template.campaignItem.events
	'click #campaignDetail': (e, tmpl) ->
		Router.go '/campaign/'+@_id


_cloudinary.after.update (user, file) ->
	if file.percent_uploaded is 100 and not file.uploading
		if $('.new-picture.in')
			$('.new-picture.in').modal('hide')