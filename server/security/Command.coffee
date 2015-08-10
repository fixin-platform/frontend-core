Commands.beforeAllowHooks = []

Commands.allow
  insert: introspect (userId, command) ->
    for hook in Commands.beforeAllowHooks
      hook.apply(@, arguments)

    throw new Match.Error("Authentication required") if not userId
    check command,
      _id: Match.StringId
      input: Object
      progressBars: [ # at least one progress bar must be present
        activityId: String
        isStarted: Boolean
        isCompleted: Boolean
        isFailed: Boolean
      ]
      isStarted: Boolean
      isCompleted: Boolean
      isFailed: Boolean
      isDryRun: Boolean
      isShallow: Boolean
      rowId: Match.Optional(Match.ObjectId(Rows))
      stepId: Match.ObjectId(Steps)
      userId: userId
      mode: Match.Optional(String)
      updatedAt: Date
      createdAt: Date
    step = Steps.findOne(command.stepId)
    throw new Match.Error("Can't insert a command for another user's step")  if command.userId isnt step.userId
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
