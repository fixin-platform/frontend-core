FastRender.onAllRoutes (path) ->
  @subscribe("meteor.loginServiceConfiguration")
  @subscribe("currentUser")
  @subscribe("Apps")
  @subscribe("Blueprints")
  @subscribe("Messages")

FastRender.route "/dashboard", (params) ->
  @subscribe("Recipes")

FastRender.route "/:appKey/:blueprintKey", (params) ->
  @subscribe("VotesCountByAppAndBlueprint", params.appKey, params.blueprintKey)

FastRender.route "/:appKey/:blueprintKey/:recipeId", (params) ->
  return if not Match.test(params.recipeId, Match.StringId) # filter out URLs like "/packages/foundation/public/images/apps/Trello.png"
  @subscribe("Recipe", params.recipeId)
  @subscribe("StepsByRecipeId", params.recipeId)
  # TODO subscribe for step rows, columns, filters

FastRender.route "/steps/:_id", (params) ->
  @subscribe("CommandsByStepId", params._id)
  @subscribe("RowsByStepId", params._id)
