Template.home.helpers
  url: ->
    Pack.get("homeUrl", "/apps")
  title: ->
    Pack.get("homeTitle", "Apps")

Template.home.onRendered ->

Template.home.events
#  "click .selector": (event, template) ->
