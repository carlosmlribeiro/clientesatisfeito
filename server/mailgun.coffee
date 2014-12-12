crypto = Npm.require 'crypto'
mailKey = process.env.MAILGUN_APP_KEY || Meteor.settings.MAILGUN_APP_KEY
mailPubKey = process.env.MAILGUN_PUBLIC_KEY || Meteor.settings.MAILGUN_PUBLIC_KEY
mailDomain = process.env.MAILGUN_DOMAIN || Meteor.settings.MAILGUN_DOMAIN
mailPassword = process.env.MAILGUN_PASSWORD || Meteor.settings.MAILGUN_PASSWORD
mailgunURL = "https://api.mailgun.net/v2/"

removeUnsubscribed = (email) ->
	console.log "removing " + email + " from unsubscribes list"
	Meteor.http.del mailgunURL + mailDomain + "/unsubscribes/" + email,
	auth: 'api:' + mailKey,
	(err, result) ->
		if err
			console.log err
		else
			console.log result

updateMailingList = (list, user) ->
	console.log "re-subscribe " + user + " in " + list
	Meteor.http.put mailgunURL + "lists/" + list + "/members/" +user,
	auth: 'api:' + mailKey,
	params:
		subscribed: 'yes',
	(err, result) ->
		if err
			console.log err
		else
			console.log result

addToMailingList = (list, user, vendedor, update) ->
	console.log "add " + user.profile.email + " to " + list
	Meteor.http.post mailgunURL + "lists/" + list + "/members",
	auth: 'api:' + mailKey,
	params:
		address: user.profile.email
		name: user.profile.name
		vars: "{\"id\":\"" + user._id + "\"}",
	(err, result) ->
		if err
			console.log err
		else
			console.log result

removeFromMailingList = (list, user) ->
	console.log "removing " + user + " from " + list
	Meteor.http.put mailgunURL + "lists/" + list + "/members/" + user,
	auth: 'api:' + mailKey,
	params:
		subscribed: 'no',
	(err, result) ->
		if err
			console.log err
		else
			console.log result

validateEmail = (email) ->
	try
		console.log "Validating email " + email
		result = Meteor.http.get mailgunURL + "address/validate",
		auth: 'api:' + mailPubKey,
		params:
			address: email

		result.data.is_valid
	catch err
		console.log err
		false

changeEmail = (old, newEmail, special) ->
	try
		if special
			list = "vendedor@" + mailDomain
		else
			list = "noticias@" + mailDomain
		console.log "change email from " + old + " to " + newEmail + " in " + list
		result = Meteor.http.put mailgunURL + "lists/" + list + "/members/" + old,
		auth: 'api:' + mailKey,
		params:
			address: newEmail
	catch err
		console.log err

Meteor.methods
	sendEmail: (name, email, template, tag, subject, data, text) ->
		console.log "sending email to " + email
		Meteor.http.post mailgunURL + mailDomain + "/messages",
		auth: 'api:' + mailKey,
		params:
			from: "Cliente Satisfeito <info@"+mailDomain+">"
			to: name + " <"+email+">"
			subject: subject
			html: Handlebars.templates[template](data)
			text: text
			o:tag: tag,
			#o:testmode: 'yes',
		(err, result) ->
			if err
				console.log err
			else
				console.log result

	unsubscribeUser: (body) ->
		#hash = body.timestamp + '' + body.token
		#if signature is crypto.createHmac('md5', hash).update(message).digest('base64')
		Meteor.users.update({'profile.email': body.recipient},{$set: {'profile.newsletter': false}});
		removeFromMailingList "noticias@" + mailDomain, body.recipient

		Meteor.users.update {'profile.email': body.recipient},{$set: {'profile.newsletterSpecial': false}} 
		removeFromMailingList "vendedor@" + mailDomain, body.recipient
		
		true

	deleteEmailUser: (email, vendedor, noticias) ->
		if noticias
			removeFromMailingList "noticias@" + mailDomain, email
		if vendedor
			removeFromMailingList "vendedor@" + mailDomain, email
		
		true

	validateEmailClient: (email) ->
		validateEmail email
		
#create user
Meteor.users.after.insert (userId, doc) ->
	try
		if doc.profile.admin
			addToMailingList "vendedor@" + mailDomain, doc, true
		
		addToMailingList "noticias@" + mailDomain, doc, false

		#sendEmail doc.profile, 'mail', "welcome"
	catch e
		# Silent Error
	
	

#update newsletter, newsletterSpecial or email
Meteor.users.after.update (userId, doc, fieldNames, modifier) ->
	try
		if modifier.$set['profile.newsletter'] is false
			removeFromMailingList "noticias@" + mailDomain, doc.profile.email
		if modifier.$set['profile.newsletterSpecial'] is false
			removeFromMailingList "vendedor@" + mailDomain, doc.profile.email
		if modifier.$set['profile.newsletter'] is true
			removeUnsubscribed doc.profile.email
			updateMailingList "noticias@" + mailDomain, doc.profile.email
		if modifier.$set['profile.newsletterSpecial'] is true
			removeUnsubscribed doc.profile.email
			updateMailingList "vendedor@" + mailDomain, doc.profile.email
	catch e
		# Silent Error

Meteor.users.before.update (userId, doc, fieldNames, modifier, options)->
	try
		if modifier.$set['profile.email']
			if validateEmail modifier.$set['profile.email']
				if doc.profile.newsletterSpecial
					changeEmail doc.profile.email, modifier.$set['profile.email'], true
				if doc.profile.newsletter
					changeEmail doc.profile.email, modifier.$set['profile.email'], false
			else
				false		
	catch e
		# Silent Error