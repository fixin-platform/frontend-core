Template.twitterFollow.helpers
  size: -> @size or "standard"
  showCount: -> @showCount or "true"

Template.twitterFollow.onCreated ->
  _.defer => twttr.ready => twttr.widgets.load(@firstNode.parentNode)

Template.twitterFollow.events
#  "click .selector": (event, template) ->
