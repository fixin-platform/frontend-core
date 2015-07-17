Template.dashboard.helpers
  recipes: ->
    Recipes.find({}, {sort: {position: -1}}) # new recipes first

Template.dashboard.onRendered ->
  @subscribe("Recipes")

Template.dashboard.events
#  "click .selector": (event, template) ->
