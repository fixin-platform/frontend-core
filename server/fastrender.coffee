FastRender.onAllRoutes (path) ->
  @subscribe("meteor.loginServiceConfiguration")
  @subscribe("currentUser")

FastRender.route "/dashboard", (params) ->
  @subscribe("RecipesOnAutorun")

#FastRender.route "/:appKey/:blueprintKey", (params) ->
#  @subscribe("VotesCountByAppAndBlueprint", params.appKey, params.blueprintKey)
