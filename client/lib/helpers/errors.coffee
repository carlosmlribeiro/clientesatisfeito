@Errors = new Mongo.Collection null

@throwError = (message, type) ->
	if not message
		message = "Ocorreu um erro"
	if not type
		type = "danger"
	Errors.insert message:message, type:type, seen:false

@clearErrors = () ->
	Errors.remove {seen: true}