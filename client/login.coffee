Meteor.startup ->
  Tracker.autorun ->
    $(window).scrollTop(0) # cause, you know, that's the most logical thing to do after logging the user in

    # fixes for modal after login
    $("body").removeClass("modal-open")
    $(".modal-backdrop").remove()

    user = Spire.currentUser({isNew: 1})
    if not user or not user.isNew
      return
    modifier = {}
    $set = {}
    # locale needs to be set here, so that we have access to browser default locale
  #    if not user.profile.locale
  #      $set["profile.locale"] = user.services?.google?.locale || i18n.lng()
  #    i18n.setLng($set["profile.locale"] or i18n.lng())
  #    moment.locale($set["profile.locale"] or i18n.lng())
  #    $.datepicker.setDefaults($.datepicker.regional[i18n.lng()] or $.datepicker.regional[""])
    if not _.isEmpty($set)
      modifier.$set = $set
    if not _.isEmpty(modifier)
      Users.update({_id: user._id}, modifier)
    # TODO possible race condition if isNew is set to false in a callback after creating an object
    _.defer ->
      if user.isNew
        Users.update(Meteor.userId(), {$set: {isNew: false}})
  #        _id = Widgets.insert({name: "My first widget"}, (error) ->
  #          if error then throw error
  #
  #        )
  #        Router.go("/widget/" + _id)
