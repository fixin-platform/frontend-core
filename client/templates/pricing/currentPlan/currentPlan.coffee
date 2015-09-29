Template.currentPlan.helpers
  currentUserCanUpgrade: ->
    plan = Spire.currentUser({planId: 1, executions: 1}).plan()
    plan._id is "free" or plan.executionsLimit
  currentUserExecutionsLeft: ->
    user = Spire.currentUser({planId: 1, executions: 1})
    plan = user.plan()
    Math.max(0, plan.executionsLimit - user.executions)

Template.currentPlan.onRendered ->

Template.currentPlan.events
#  "click .selector": (event, template) ->
