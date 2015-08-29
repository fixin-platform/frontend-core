Template.recipe.helpers
  app: ->
    Apps.findOne({key: Spire.getParam("appKey")})
  blueprint: ->
    app = Apps.findOne({key: Spire.getParam("appKey")})
    Blueprints.findOne({key: Spire.getParam("blueprintKey"), appId: app._id})
  recipe: ->
    Recipes.findOne(Spire.getParam("recipeId"))
  recipeBodyData: ->
    recipeId: Spire.getParam("recipeId")

Template.recipe.onCreated ->
  @subscribe("Recipes")
