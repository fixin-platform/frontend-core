# It's possible to have Meteor.userId(), but not Meteor.user()
# This may happen in web app if fast-render hasn't initialized yet => hasn't provided the user data for Meteor.user()
# This always happens in extension, because there's no fast-render

@mixpanelLoaded = (mixpanel) ->
  Pack.call("preMixpanelLoaded", mixpanel)
  Deps.autorun (computation) ->
    return if not Spire.currentUserReady()
    user = Meteor.user()
    if user.isInternal or Spire.isAutologin()
      mixpanel.disable()
    if user.isAliasedByMixpanel
      mixpanel.identify(user._id)
    else
      # We can't save distinct_id on user because there are many places on server where we need to track event based in userId alone (without having to fetch the user from database)
      # We also can't save distinct_id on user because some users block Mixpanel, so I have to sync them manually. However, they perform actions while unsynced, which should be attributed to userId
      Meteor.call("alias", mixpanel.get_distinct_id(), Spire.handleError())
    mixpanel.people.set({_id: user._id}) # just to set country and browser information
    computation.stop() # prevent duplicate $signup and duplicate call to identify
    # Logout must reload the page; otherwise the next login won't be tracked, because this computation will have been stopped by then

Pack.call("preGoogleAnalyticsLoaded")
