Recipes.allow
  insert: introspect (userId, recipe) ->
    throw new Match.Error("Authentication required") if not userId
    check(recipe, Match.ObjectIncluding
      name: String
      appId: Match.ObjectId(Apps)
      blueprintId: Match.ObjectId(Blueprints)
      cls: String # TODO: check for class presence
      userId: userId
      updatedAt: Date
      createdAt: Date
    )
    if Blueprints.findOne(recipe.blueprintId).appId isnt recipe.appId
      throw new Match.Error("Wrong appId or blueprintId")
    true
  update: introspect (userId, recipe, fieldNames, modifier, options) ->
    throw new Match.Error("Authentication required") if not userId
    throw new Match.Error("Only owner can do this") if recipe.userId isnt userId
    updatedImmutableFields = _.intersection(fieldNames, ["blueprintId", "cls", "userId", "createdAt"])
    throw new Match.Error("Can't update immutable fields: #{JSON.stringify(updatedImmutableFields)}") if updatedImmutableFields.length
    return true
  remove: introspect (userId, recipe) ->
    throw new Match.Error("Authentication required") if not userId
    throw new Match.Error("Only owner can do this") if recipe.userId isnt userId
    true
