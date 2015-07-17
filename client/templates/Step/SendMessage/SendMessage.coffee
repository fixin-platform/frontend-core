Template.SendMessage.helpers
  success: ->
    @field("status") is "success"
  failure: ->
    @field("status") is "failure"
  loading: ->
    @field("status") is "loading"

Template.SendMessage.onRendered ->

Template.SendMessage.events
  "click button": grab encapsulate (event, template) ->
    template.data.execute()
