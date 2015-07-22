Template.autorunCount.helpers
  autorunCount: ->
    Recipes.find({isAutorun: true}).count() or 0
