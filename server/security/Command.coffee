Commands.beforeAllowHooks = []

Commands.allow
  insert: introspect (userId, command) ->
    for hook in Commands.beforeAllowHooks
      hook.apply(@, arguments)
    throw new Match.Error("Authentication required") if not userId
    throw new Match.Error("Only owner can do this") if command.userId isnt userId
    check command, Commands.match()
    step = Steps.findOne(command.stepId)
    throw new Match.Error("Can't insert a command for another user's step") if command.userId isnt step.userId
    true
  update: introspect (userId, command, fieldNames, modifier, options) ->

    throw new Match.Error("Can't update existing command (it may already be executing)")

    throw new Match.Error("Authentication required") if not userId
    throw new Match.Error("Only owner can do this") if command.userId isnt userId
    updatedImmutableFields = _.intersection(fieldNames, ["rowId", "stepId", "userId", "createdAt"])
    throw new Match.Error("Can't update immutable fields: #{JSON.stringify(updatedImmutableFields)}") if updatedImmutableFields.length
    true
  remove: introspect (userId, command) ->
    throw new Match.Error("Authentication required") if not userId
    throw new Match.Error("Only owner can do this") if command.userId isnt userId
    true
