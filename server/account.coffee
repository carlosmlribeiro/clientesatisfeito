Meteor.methods
	activateAccount: (id, ref) ->
		
		activationURL = Meteor.absoluteUrl() + '?ref=' + id
		
		#make validations - validate if user has CREATE_CONTENT
		userAccount = _.findWhere(Meteor.user().accounts, {id: id})

		if not _.contains(userAccount.perms, "CREATE_CONTENT")
			throw new Meteor.Error '403', "Para activar a página precisa de permissões para criar conteúdo na mesma", "danger"

		#if referral account +1 in ref account
		result = Account.findOne({"_id": id}, {fields: {_id:0, name:1}})

		if ref
			Account.update {"_id": ref}, {"$inc": {"numRef": 1}}

		#update to pending
		Meteor.users.update {"_id": Meteor.userId(), "profile.accounts.id": id}, {"$set": {"profile.accounts.$.status": "pending", "profile.accounts.$.activationURL": activationURL}}
		Meteor.users.update {"_id": Meteor.userId(), "accounts.id": id}, {"$set": {"accounts.$.status": "pending", "accounts.$.activationURL": activationURL}}
		Account.update {"_id": id}, {"$set": {"status": "pending", "activationURL": activationURL}}

		@unblock
		#send email
		Meteor.call 'sendEmail', Meteor.user().profile.name, Meteor.user().profile.email, 'activateAccount', '', "Bem vindo ao Cliente Satisfeito, " + result.name, {url: encodeURIComponent(activationURL), name: result.name}, "Bem vindo ao Cliente Satisfeito.pt\n\nObrigado por se ter registado no Cliente Satisfeito. Estamos neste momento em fase de pré-inscrição, e precisamos da vossa ajuda para dar a conhecer o Cliente Satisfeito.\n\nPartilha o Cliente Satisfeito e se 5 novos utilizadores se registarem a partir da vossa indicação ficaram para sempre como Clientes Pioneiros, com acesso privilegiado a toda a aplicação.\n\nPara tal, utilizem os botões aqui presentes para dar a conhecer a aplicação ao maior número de pessoas possível. A nossa visão é um Portugal repleto de Clientes Satisfeitos.\n\nBrevemente a aplicação estará disponível. Não se esqueçam de gostar da nossa página no Facebook para estarem a par das novidades.\n\n\nPara não receber mais email siga este link <%unsubscribe_url%>", (err, result) ->
			if err
				console.log err
		
		'pending'

	setToActive: (id) ->

		#get userid from account creator
		result = Account.findOne({"_id": id}, {fields: {_id:0, creator:1}})

		Meteor.users.update {"_id": result.creator, "profile.accounts.id": id}, {"$set": {"profile.accounts.$.status": "active"}}
		Meteor.users.update {"_id": result.creator, "accounts.id": id}, {"$set": {"accounts.$.status": "active"}}
		Account.update {"_id": id}, {"$set": {"status": "active"}}
