Template.RecipeListRoute.helpers
  page: ->
    Pages.findOne({url: Spire.getParam("url")})

Template.RecipeListRoute.onCreated ->
  console.log
  @autorun => # @autorun is necessary, because template data may change without re-render => without calling onCreated next time
    currentData = Template.currentData()
    @subscribe "Page", currentData.url
    @subscribe "RecipesByPageUrl", currentData.url
  @autorun (computation) =>
    if @subscriptionsReady()
      computation.stop()
      currentData = Template.currentData()
      page = Pages.findOne({url: currentData.url})
      if not page.recipes().count()
        recipe = page.generateRecipe({userId: Meteor.userId()})
        FlowRouter.go(recipe.url())


Template.RecipeListRoute.events
  "click .insert-recipe": grab encapsulate (event, template) ->
    page = Pages.findOne({url: template.data.url})
    recipe = page.generateRecipe({userId: Meteor.userId()})
    FlowRouter.go(recipe.url())
