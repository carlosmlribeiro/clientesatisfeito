Template.campaignItem.events
	'click #campaignDetail': (e, tmpl) ->
		Router.go '/campaign/'+@_id

Template.campaignItem.helpers
	myProgress: (progress) ->
		Math.round((progress?.loaded? * 100.0) / progress?.total?)