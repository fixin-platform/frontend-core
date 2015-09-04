Recipes.allow
  insert: introspect (userId, recipe) ->
    throw new Match.Error("Authentication required") if not userId
    throw new Match.Error("Only owner can do this") if recipe.userId isnt userId
    check recipe, Recipes.match()
    true
  update: introspect (userId, recipe, fieldNames, modifier, options) ->
    throw new Match.Error("Authentication required") if not userId
    throw new Match.Error("Only owner can do this") if recipe.userId isnt userId
    updatedImmutableFields = _.intersection(fieldNames, ["cls", "userId", "createdAt"])
    throw new Match.Error("Can't update immutable fields: #{JSON.stringify(updatedImmutableFields)}") if updatedImmutableFields.length
    return true
  remove: introspect (userId, recipe) ->
    throw new Match.Error("Authentication required") if not userId
    throw new Match.Error("Only owner can do this") if recipe.userId isnt userId
    true
