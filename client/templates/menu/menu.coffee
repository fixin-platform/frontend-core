Template.menu.helpers
  recipesCount: ->
    Counts.get("Recipes")
#  Recipes.find({isAutorun: true}).count() or 0

Template.menu.onRendered ->

Template.menu.onCreated ->
  @subscribe("RecipesCount")

Template.menu.events
