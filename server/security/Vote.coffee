Votes.allow
  insert: introspect (userId, vote) ->
    true
  update: introspect (userId, vote, fieldNames, modifier, options) ->
    false
  remove: introspect (userId, vote) ->
    false
