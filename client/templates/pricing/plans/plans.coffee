Template.plans.helpers
  plans: ->
    _.where(Spire.plans, {period: Spire.getParam("period") or Session.get("period")})
  alternative: ->
    _.findWhere(Spire.plans, {_id: @alternativeId})

Template.plans.onRendered ->

Template.plans.events
#  "click .selector": (event, template) ->
