Template.currentPlan.helpers
  weRequireMoreVespeneGas: ->
    currentUserPlan = UI._globalHelpers.currentUserPlan.call(@)
    currentUserPlan._id is "free" or currentUserPlan.activeRecipesLimit

Template.currentPlan.onRendered ->

Template.currentPlan.events
#  "click .selector": (event, template) ->
