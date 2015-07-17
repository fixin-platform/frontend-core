Template.recipe.helpers
  app: ->
    Apps.findOne({key: Foreach.getParam("appKey")})
  blueprint: ->
    app = Apps.findOne({key: Foreach.getParam("appKey")})
    Blueprints.findOne({key: Foreach.getParam("blueprintKey"), appId: app._id})
  recipe: ->
    Recipes.findOne(Foreach.getParam("recipeId"))
  recipeBodyData: ->
    recipeId: Foreach.getParam("recipeId")
