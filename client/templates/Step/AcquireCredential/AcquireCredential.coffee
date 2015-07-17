Template.AcquireCredential.helpers

Template.AcquireCredential.onRendered ->

Template.AcquireCredential.events
  "click .connect-to-api": grab encapsulate (event, template) ->
    $target = $(event.currentTarget)
    $target.find(".ready").hide()
    $target.find(".loading").show()
    connect(@api, @scopes, _.wrap(@callback, (parent, args...) ->
      $target.find(".ready").show()
      $target.find(".loading").hide()
      parent?.apply(@, args)
    ))
