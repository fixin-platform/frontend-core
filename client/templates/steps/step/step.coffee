Template.step.helpers
  step: ->
    Steps.findOne(@_id)

Template.step.onCreated ->
  @subscribe("Step", @data._id)
