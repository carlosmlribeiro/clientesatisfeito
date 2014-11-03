Template.navbarHomepageMenu.events
	'click #toplogin': (e, tmpl) ->
		login()

	'click #about-btn': (e,tmpl) ->
		e.preventDefault()
		$('body').animate
			scrollTop: $('#about').offset().top
			, 400

	'click #how-btn': (e,tmpl) ->
		e.preventDefault()
		$('body').animate
			scrollTop: $('#how').offset().top
			, 400

	'click #why-btn': (e,tmpl) ->
		e.preventDefault()
		$('body').animate
			scrollTop: $('#why').offset().top
			, 400