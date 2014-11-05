Meteor.methods
	activateAccount: (id) ->
		
		activationURL = Meteor.absoluteUrl() + '?ref=' + id
		
		#make validations - validate if user has CREATE_CONTENT
		userAccount = _.findWhere(Meteor.user().accounts, {id: id})

		if not _.contains(userAccount.perms, "CREATE_CONTENT")
			throw new Meteor.Error '403', "Para activar a página precisa de permissões para criar conteúdo na mesma", "danger"

		#if referral account +1 in ref account
		result = Account.findOne({"_id": id}, {fields: {_id:0, referral:1, name:1}})

		if result.referral
			Account.update {"_id": result.referral}, {"$inc": {"numRef": 1}}

		#update to pending
		Meteor.users.update {"_id": Meteor.userId(), "profile.accounts.id": id}, {"$set": {"profile.accounts.$.status": "pending", "profile.accounts.$.activationURL": activationURL}}
		Meteor.users.update {"_id": Meteor.userId(), "accounts.id": id}, {"$set": {"accounts.$.status": "pending", "accounts.$.activationURL": activationURL}}
		Account.update {"_id": id}, {"$set": {"status": "pending", "activationURL": activationURL}}

		#send email
		Meteor.call 'sendEmail', Meteor.user(), 'activateAccount', '', "Bem vindo ao Cliente Satisfeito, " + result.name, {url: encodeURIComponent(activationURL), name: result.name}, (err, result) ->
			if err
				console.log err
		
		'pending'