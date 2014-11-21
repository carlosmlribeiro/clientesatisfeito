Template.index.events
	'click #login': (e, tmpl) ->
		if ga?
			ga('send','event','login','centerlogin')
		login()

	'click #about-btn-bottom': (e,tmpl) ->
		e.preventDefault()
		$('body').animate
			scrollTop: $('#about').offset().top
			, 400

	'click #facebook-btn': (e,tmpl) ->
		e.preventDefault()
		$('body').animate
			scrollTop: $('#facebook').offset().top
			, 400