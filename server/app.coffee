Spire.named2positional = (query, replacements) ->
  for name, position of replacements
    query = query.replace(new RegExp(":#{name}", "g"), position)
  query
