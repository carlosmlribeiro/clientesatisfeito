Template.campaign.helpers
	isOwner: () ->
		Meteor.user()?.profile?.activeAccount?.id is @accountId and Meteor.user()?.profile?.admin

	translateStatus: (status) ->
        if status is 'created'
            'Cliente Adicionado'
        else if status is 'claimed'
            "Promoção reclamada"
        else if status is 'shared'
            "Cliente Satisfeito"
        else
            'Cliente Não Satisfeito'

    isAdmin: () ->
        Meteor.user()?.profile?.admin