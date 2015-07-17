TokenEmails.allow
  insert: introspect (userId, TokenEmail) ->
    true
  update: introspect (userId, TokenEmail, fieldNames, modifier, options) ->
    false
  remove: introspect (userId, TokenEmail) ->
    false
