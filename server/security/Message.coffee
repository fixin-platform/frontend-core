Messages.allow
  insert: introspect (userId, message) ->
    throw new Match.Error("Authentication required") if not userId
    true
  update: introspect (userId, message, fieldNames, modifier, options) ->
    throw new Match.Error("Authentication required") if not userId
    throw new Match.Error("Only owner can do this") if message.userId isnt userId
    return true
  remove: introspect (userId, message) ->
    throw new Match.Error("Authentication required") if not userId
    throw new Match.Error("Only owner can do this") if message.userId isnt userId
    true
