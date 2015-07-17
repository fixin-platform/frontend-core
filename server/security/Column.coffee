Columns.allow
  insert: introspect (userId, column) ->
    throw new Match.Error("Authentication required") if not userId
    check(column, Match.ObjectIncluding
      _id: Match.StringId
      name: String
      cls: String
      position: Match.Integer
      stepId: Match.ObjectId(Steps)
      userId: userId
      updatedAt: Date
      createdAt: Date
    )
    true
  update: introspect (userId, column, fieldNames, modifier, options) ->
    throw new Match.Error("Authentication required") if not userId
    throw new Match.Error("Only owner can do this") if column.userId isnt userId
    updatedImmutableFields = _.intersection(fieldNames, ["stepId", "userId", "createdAt"])
    throw new Match.Error("Can't update immutable fields: #{JSON.stringify(updatedImmutableFields)}") if updatedImmutableFields.length
    true
  remove: introspect (userId, column) ->
    throw new Match.Error("Authentication required") if not userId
    throw new Match.Error("Only owner can do this") if column.userId isnt userId
    throw new Match.Error("This object is non-removable") if not column.isRemovable
    true
