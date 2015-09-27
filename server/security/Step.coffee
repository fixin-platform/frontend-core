Steps.allow
  insert: introspect (userId, step) ->
    throw new Match.Error("Authentication required") if not userId
    throw new Match.Error("Only owner can do this") if step.userId isnt userId
    check step, Match.ObjectIncluding(Steps.match())
    recipe = Recipes.findOne(step.recipeId)
    throw new Match.Error("Can't insert a step for another user's recipe") if step.userId isnt recipe.userId
    true
  update: introspect (userId, step, fieldNames, modifier, options) ->
    throw new Match.Error("Authentication required") if not userId
    throw new Match.Error("Only owner can do this") if step.userId isnt userId
    updatedImmutableFields = _.intersection(fieldNames, ["cls", "recipeId", "userId", "createdAt"])
    throw new Match.Error("Can't update immutable fields: #{JSON.stringify(updatedImmutableFields)}") if updatedImmutableFields.length
    return true
  remove: introspect (userId, step) ->
    throw new Match.Error("Authentication required") if not userId
    throw new Match.Error("Only owner can do this") if step.userId isnt userId
    throw new Match.Error("This object is non-removable") if not step.isRemovable
    true
