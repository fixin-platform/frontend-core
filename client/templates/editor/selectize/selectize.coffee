Template.selectize.helpers
#  helper: ->

Template.selectize.onRendered ->
  $(@firstNode).selectize(@data.selectizeOptions())

Template.selectize.events
#  "click .selector": (event, template) ->
