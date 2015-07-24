Template.similarRecipes.helpers
  similar: ->
    similar =
      scheduled: Recipes.find({_id: {$ne: @recipeId}, blueprintId: @recipe().blueprintId, isAutorun: true})
      manual: Recipes.find({_id: {$ne: @recipeId}, blueprintId: @recipe().blueprintId, isAutorun: false})
    similar  if similar.scheduled.count() or similar.manual.count()

Template.similarRecipes.onRendered ->
  $collapse = @$(".collapse")
  $collapse.collapse(toggle: false).on "show.bs.collapse", ->
    $collapse.collapse("hide")
