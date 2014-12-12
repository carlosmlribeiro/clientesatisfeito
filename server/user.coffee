Accounts.onCreateUser (options, user) ->
    user.profile = 
        name: user.services.facebook.name
        fbid: user.services.facebook.id
        locale: user.services.facebook.locale
        email: user.services.facebook.email
        newsletter: true

    user = Meteor.call 'getPages', user, true

    user

Meteor.methods
	deleteUser: (userId) ->
		if userId is not Meteor.userId()
			throw new Meteor.Error 403, "Só pode apagar o próprio utilizador", "danger"

		#delete from mailgun
		Meteor.call "deleteEmailUser", Meteor.user().profile.email, Meteor.user().profile.newsletterSpecial, Meteor.user().profile.newsletter, (err, result) ->
			if err
				console.log err

			#save in deletedUsers table
			Meteor.users.remove {_id: userId}

	getPages: (user, noupdate) ->
		user = user || Meteor.user()
		noupdate = noupdate || false
		stillActive = false
		user.profile.admin = false

		data = ServerCookies.retrieve @connection 

		if data?.cookies?.ref
			user.profile.referral = data.cookies.ref

		accessToken = user.services.facebook.accessToken
		
		result = Meteor.http.get "https://graph.facebook.com/" + user.services.facebook.id + "/accounts?fields=category,name,access_token,id,about,perms,can_post,emails,new_like_count,website,likes,location&offset=0&limit=1000",
			params:
				access_token: accessToken

		if result.data.error
			throw new Meteor.Error result.data.error.code, result.data.error.message, "danger"

		#clean old data
		user.accounts = []
		user.profile.accounts = []

		if result.data.data	

			if result.data.data.length > 0
				user.profile.admin = true	
				if noupdate #new user
					user.profile.newsletterSpecial = true
			else if not noupdate #only throw error for old users
				throw new Meteor.Error 412, "Para ser vendedor tem que ser administrador de uma página facebook", "warning"

			for account in result.data.data
	        	#create account
	        	if !Account.findOne {_id: account.id}
	        		account.status = "inactive"
	        		account.creator = user._id
	        		account._id = account.id
	        		account.referral = user.profile.referral
	        		account.posts = []
	        		account.numRef = 0

	        		Account.insert account
	        	else
	        		oldStatusDoc = Account.findOne( {_id: account.id }, { status: 1, _id: 0})
	        		account.status = oldStatusDoc.status
	        		#also, update account collection

	        	if user.profile.activeAccountId is account.id
	        		stillActive = true

	        	#add to user accounts
	        	user.accounts.push(account)

	        	#add to user permissions
	        	user.profile.accounts.push({name: account.name, id: account.id, category: account.category, status: account.status})    

	        if !stillActive
	        	user.profile.activeAccountId = null

	    if noupdate
	    	user
    	else
    		Meteor.users.update( { _id: Meteor.userId() }, { $set: { 'profile': user.profile, 'accounts': user.accounts }} )

#deny users to set profile.admin to true if no accountsand profile.accounts
Meteor.users.deny
	update: (userId, doc, fields, modifier) ->
		if _.findWhere(modifier, 'profile.admin': true) is undefined || Meteor.user().profile.accounts.length > 0
			false
		else
			true