Tracker.autorun ()->
	if qrScanner.message()?.indexOf "campaign" isnt -1 and qrScanner.message()?.indexOf "promotion" isnt -1
		console.log qrScanner.message()
		array = qrScanner.message().split("/")
		for string, index in array
			if string is "campaign"
				campaignId = array[index+1]
			if string is "promotion"
				id = array[index+1]

		if campaignId and id
			Router.go "promotion", {_id: id, campaignId: campaignId}