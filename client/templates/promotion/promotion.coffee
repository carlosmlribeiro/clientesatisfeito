Template.promotion.helpers
	isOwner: () ->
		@promotion?.ownedBy is Meteor.userId()

	isShared: () ->
		@promotion.status is "shared"

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
				throwError 'Ocorreu um erro! A sua mensagem não foi partilhada!', "danger"
				$("#btnText").text 'Partilhar no Facebook'
				$("#share").removeAttr 'disabled'
			else
				$("#btnText").text 'Partilhado'



	'click #complain': (e, tmpl) ->
		#todo