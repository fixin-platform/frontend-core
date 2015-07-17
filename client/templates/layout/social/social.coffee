Template.social.helpers
#  helper: ->

Template.social.onRendered ->
  if typeof(gapi) isnt "undefined" # loaded
    $(@findAll(".g-plusone")).each (index, element) ->
      gapi.plusone.render(element, $(element).data())
  if typeof(FB) isnt "undefined" # loaded
    $(@findAll(".fb-button")).each (index, element) ->
      FB.XFBML.parse(element.parentNode)

Template.social.events
#  "click .selector": (event, template) ->
