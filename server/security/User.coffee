Users.allow
  insert: introspect (userId, user) ->
    true
  update: introspect (userId, user, fieldNames, modifier, options) ->
    if isAdmin(userId)
      return true
    if user._id isnt userId
      return false
    updatedImmutableFields = _.intersection(fieldNames, ["stripeCustomerId", "createdAt"])
    throw new Match.Error("Can't update immutable fields: #{JSON.stringify(updatedImmutableFields)}") if updatedImmutableFields.length
    return true
  remove: introspect (userId, user) ->
    false
  fetch: ['_id']
