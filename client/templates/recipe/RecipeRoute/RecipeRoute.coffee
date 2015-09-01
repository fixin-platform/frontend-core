Template.RecipeRoute.helpers
  recipe: ->
    Recipes.findOne(@recipeId)

Template.RecipeRoute.onCreated ->
  @autorun => # @autorun is necessary, because template data may change without re-render => without calling onCreated next time
    currentData = Template.currentData()
    @subscribe("Recipe", currentData.recipeId)
    @subscribe("StepsByRecipeId", currentData.recipeId)
