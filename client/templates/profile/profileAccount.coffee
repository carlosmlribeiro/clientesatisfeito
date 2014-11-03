Template.profileAccount.events
    'click .activatePage': (e, tmpl) ->
        id = @id
        status = Meteor.call "activateAccount", id, (err, result) ->
            if err
                throwError err.message, err.details
            if result is 'pending'
                $('#pendingWarning'+ id).modal
                    show: true

    'click .shareFacebook': (e, tmpl) ->
        $(e.target).attr('disabled','disabled');
        
        Meteor.call 'shareOnFacebook', @id, @access_token, @activationURL, (err, result) ->
            if err
                $('#errormsg').append("<p>" + err.message + "</p>") 

            if result
                $(e.target).text('Partilhado');

Template.profileAccount.helpers
	activeAccountClass: (status) ->
    	if status is 'active'
    		'panel-success'
    	else if status is 'pending'
    		'panel-warning'
    	else
    		'panel-default'

	activeAccountIcon: (status) ->
    	if status is 'active'
    		'glyphicon-ok'
    	else if status is 'pending'
    		'glyphicon-warning-sign'
    	else
    		'glyphicon-remove'

    translate: (status) ->
        if status is 'active'
            'Activa'
        else if status is 'pending'
            "Activação pendente"
        else
            'Inactiva'

    accountInactive: (status) ->
        if status is 'inactive'
            true
        else
            false

    accountPending: (status) ->
        if status is 'pending'
            true
        else
            false