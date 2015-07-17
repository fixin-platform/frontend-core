Users.allow
  insert: introspect (userId, user) ->
    true
  update: introspect (userId, user, fieldNames, modifier, options) ->
    if isAdmin(userId)
      return true
    if user._id isnt userId
      return false
    if "actions" in fieldNames and user._id not in Foreach.fixtureIds
      return false
    return true
  remove: introspect (userId, user) ->
    false
  fetch: ['_id']
