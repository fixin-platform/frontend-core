Template.twitterShare.helpers
  size: -> @size or "standard"
  related: -> @related or "HappyFixin"
  # url must be set explicitly, because Twitter doesn't pick up the routing changes

Template.twitterShare.onRendered -> # onRendered, because we need @firstNode.parentNode
  _.defer => twttr.ready => twttr.widgets.load(@firstNode.parentNode)
#  twttr.ready => twttr.widgets.createShareButton(@data.url, @firstNode.parentNode,
#    text: @data.text
#    size: @data.size or "standard"
#    related: @data.related or "HappyFixin"
#  )

Template.twitterShare.events
#  "click .selector": (event, template) ->

