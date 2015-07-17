Accounts.onLogin (info) ->
  # Meteor calls onLogin even when already logged-in user reloads the page
  # Disabled, because it's not really helpful + looks like it generates too many random events (not really related to login)
#  mixpanel.track("AuthenticatedPageload", {userId: info.user._id})

Messages.after.insert (userId, message) ->
  mixpanel.track("InternalMessageSent", _.defaults({userId: userId}, message))
  true
