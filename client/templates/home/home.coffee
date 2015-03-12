Template.home.helpers
  campaign: ->
    Campaign.find {}, {sort: {'created': -1}}

  noCampaigns: ->
  	Campaign.find().count() is 0