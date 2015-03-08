Template.promotionMain.events
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

Template.promotionMain.helpers
	myProgress: (progress) ->
		Math.round((progress?.loaded? * 100.0) / progress?.total?)

Template.promotionMain.rendered = () ->
	window.Holder.run()