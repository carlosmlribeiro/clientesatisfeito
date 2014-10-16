@Errors = new Meteor.Collection null

@throwError = (message, type) ->
	if not message
		message = "Ocorreu um erro"
	Errors.insert message:message, type:type, seen:false

@clearErrors = () ->
	Errors.remove {seen: true}