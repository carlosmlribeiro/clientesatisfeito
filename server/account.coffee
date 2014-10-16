Meteor.methods
	activateAccount: (id) ->
		
		activationURL = Meteor.absoluteUrl() + '?ref=' + id
		
		#make validations

		#if referral account +1 in ref account
		result = Account.findOne({"_id": id}, {fields: {_id:0, referral:1}})

		if result.referral
			Account.update {"_id": result.referral}, {"$inc": {"numRef": 1}}

		#update to pending
		Meteor.users.update {"_id": Meteor.userId(), "profile.accounts.id": id}, {"$set": {"profile.accounts.$.status": "pending", "profile.accounts.$.activationURL": activationURL}}
		Meteor.users.update {"_id": Meteor.userId(), "accounts.id": id}, {"$set": {"accounts.$.status": "pending", "accounts.$.activationURL": activationURL}}
		Account.update {"_id": id}, {"$set": {"status": "pending", "activationURL": activationURL}}
		
		'pending'