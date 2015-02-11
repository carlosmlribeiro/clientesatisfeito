Template.promotion.helpers
	isOwner: () ->
		@promotion?.ownedBy is Meteor.userId()

	isExpired: () ->
		@promotion.status is "shared" or @promotion.status is "complain"

Template.promotion.events
	'click #login': (e, tmpl) ->
		if ga?
			ga('send','event','login','promotionlogin')
		login()

	'click #customer-mode': (e,tmpl) ->
		Meteor.users.update(Meteor.userId(), {$set: {'profile.admin': false}})

	'click #claim': (e, tmpl) ->
		Meteor.call "claimPromotion", @promotionId, @campaign._id

	'click #share': (e, tmpl) ->
		e.preventDefault()
		$("#btnText").text 'A partilhar...'
		$("#share").attr 'disabled','disabled'
		$("#complain").attr 'disabled','disabled'
		Meteor.call "sharePromotion", @campaign._id, @promotionId, $('#comment').val(), @promotion.imageURL, (err, result) ->
			if err
				throwError 'Ocorreu um erro! A sua mensagem não foi partilhada! (' + err.message + ')', "danger"
				$("#btnText").text 'Partilhar no Facebook'
				$("#share").removeAttr 'disabled'
				$("#complain").removeAttr 'disabled'
			else
				$("#btnText").text 'Partilhado'

	'click #complain': (e, tmpl) ->
		e.preventDefault()
		$("#share").attr 'disabled','disabled'
		$("#complain").attr 'disabled','disabled'
		if $('#comment').val()
			Meteor.call "addComplain", @campaign._id, @promotionId, @promotion.account.id, $('#comment').val(), (err, result) ->
				if err
					throwError 'Ocorreu um erro! A sua mensagem não foi enviada! (' + err.message + ')', "danger"
		else
			throwError 'É necessário preencher uma mensagem para informar o vendedor porque não ficou satisfeito!', "danger"
			$("#share").removeAttr 'disabled'
			$("#complain").removeAttr 'disabled'

Template.promotion.rendered = () ->
	Holder.run()