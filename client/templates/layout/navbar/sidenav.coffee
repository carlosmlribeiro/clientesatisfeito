Template.sidenav.events
	'click .disabled': (e) ->
		e.preventDefault()

Template.sidenav.helpers
	isSuperAccount: (id) ->
		if id is "550434438435613"
				true
		else
			false