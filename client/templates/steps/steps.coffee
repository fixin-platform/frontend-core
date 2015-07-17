Template.steps.helpers
  steps: ->
    Steps.find({}, {sort: {createdAt: 1}})

Template.steps.onCreated ->
  @subscribe("Steps")

Template.steps.events
#  "click .selector": (event, template) ->
