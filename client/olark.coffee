window.olarkOnReady = ->
  Meteor.startup ->
    Deps.autorun ->
      user = Meteor.user()
      if not user
        return
      olark('api.visitor.updateEmailAddress', {emailAddress: user.emails[0].address})
      olark('api.visitor.updateFullName', {fullName: user.profile.name})
      _.defer ->
        $olrkContainer = $(".action .olrk-container")
        if not $olrkContainer.attr("data-olark-attached")
          $olrkContainer.prepend($(".olrk-available").parent())
          $olrkContainer.find(".habla_window_div_base").css(
            position: "absolute"
            margin: "auto"
          )
          $olrkContainer.attr("data-olark-attached", "true")

