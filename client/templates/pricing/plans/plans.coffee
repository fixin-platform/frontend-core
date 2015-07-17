Template.plans.helpers
  plans: -> _.where(Foreach.plans, {period: Foreach.getParam("period") or Session.get("period")})
  alternative: -> _.findWhere(Foreach.plans, {_id: @alternativeId})

Template.plans.onRendered ->

Template.plans.events
#  "click .selector": (event, template) ->
