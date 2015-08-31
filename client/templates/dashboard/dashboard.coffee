Template.dashboard.helpers
  recipes: ->
    Recipes.find({isAutorun: true}, {sort: {position: -1}}) # new recipes first

Template.dashboard.onCreated ->
  @subscribe("RecipesOnAutorun")

Template.dashboard.events
#  "click .selector": (event, template) ->
