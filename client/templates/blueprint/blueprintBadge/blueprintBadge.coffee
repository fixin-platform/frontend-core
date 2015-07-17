Template.blueprintBadge.helpers
#  helper: ->

Template.blueprintBadge.onRendered ->

Template.blueprintBadge.events
  "click a": grab encapsulate secure (event, template) ->
    if @isImplemented
      recipe = @generateRecipe(
        userId: Meteor.userId()
      )
      FlowRouter.go(recipe.url())
    else
      FlowRouter.go(@url()) # show blueprintTeaser
