Filters.allow
  insert: introspect (userId, filter) ->
    throw new Match.Error("Authentication required") if not userId
    check(filter, Match.ObjectIncluding
      _id: Match.StringId
      cls: String
      position: Match.Integer
      columnId: Match.ObjectId(Columns)
      stepId: Match.ObjectId(Steps)
      userId: userId
      updatedAt: Date
      createdAt: Date
    )
    true
  update: introspect (userId, filter, fieldNames, modifier, options) ->
    throw new Match.Error("Authentication required") if not userId
    throw new Match.Error("Only owner can do this") if filter.userId isnt userId
    updatedImmutableFields = _.intersection(fieldNames, ["stepId", "userId", "createdAt"])
    throw new Match.Error("Can't update immutable fields: #{JSON.stringify(updatedImmutableFields)}") if updatedImmutableFields.length
    return true
  remove: introspect (userId, filter) ->
    throw new Match.Error("Authentication required") if not userId
    throw new Match.Error("Only owner can do this") if filter.userId isnt userId
    throw new Match.Error("This object is non-removable") if not filter.isRemovable
    true
