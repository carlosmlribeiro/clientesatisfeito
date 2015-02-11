ServiceConfiguration.configurations.remove
	service: "facebook"

ServiceConfiguration.configurations.insert
	service: "facebook"
	appId: process.env.FACEBOOK_APP_ID || Meteor.settings.FACEBOOK_APP_ID
	secret: process.env.FACEBOOK_APP_SECRET || Meteor.settings.FACEBOOK_APP_SECRET
	loginStyle: "redirect"

Cloudinary.config
	cloud_name: process.env.CLOUDINARY_CLOUD_NAME || Meteor.settings.CLOUDINARY_CLOUD_NAME
	api_key: process.env.CLOUDINARY_KEY || Meteor.settings.CLOUDINARY_KEY
	api_secret: process.env.CLOUDINARY_SECRET || Meteor.settings.CLOUDINARY_SECRET