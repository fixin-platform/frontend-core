Template.StartWorkflowExecutionSwitchbox.helpers
#  helper: ->

Template.StartWorkflowExecutionSwitchbox.onRendered ->
  @$("input").bootstrapSwitch()

Template.StartWorkflowExecutionSwitchbox.events
#  "click .selector": (event, template) ->
