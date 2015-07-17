Template.tweet.helpers
#  helper: ->

Template.tweet.onRendered ->
  twttr.widgets?.load(@firstNode.parentNode)

Template.tweet.events
#  "click .selector": (event, template) ->
