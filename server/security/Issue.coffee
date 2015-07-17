Issues.allow
  insert: introspect (userId, issue) ->
    false
  update: introspect (userId, issue, fieldNames, modifier, options) ->
    false
  remove: introspect (userId, issue) ->
    throw new Match.Error("Authentication required") if not userId
    throw new Match.Error("Only owner can do this") if issue.userId isnt userId
    true
