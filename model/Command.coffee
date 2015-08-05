Transformations["Command"] = (object) -> Transformations.static(Commands.Command, object)
Commands = Collections["Command"] = new Mongo.Collection("Commands", {transform: if Meteor.isClient then Transformations.Command else null})

class Commands.Command
  constructor: (doc) ->
    _.extend(@, doc)
  step: ->
    Steps.findOne(@stepId)

CommandPreSave = (userId, changes) ->
  now = new Date()
  changes.updatedAt = changes.updatedAt or now

Commands.before.insert (userId, Command) ->
  Command._id ||= Random.id()
  now = new Date()
  _.defaults(Command,
    params: {}
    progressBars: []
    isStarted: false
    isCompleted: false
    isFailed: false
    isDryRun: true # POST/PUT/DELETE and also "GET/HEAD with side-effects" are disallowed
    isShallow: false # with task hierarchy
#    stepId: ""
    userId: userId
    updatedAt: now
    createdAt: now
  )
#  throw new Meteor.Error("Command:stepId:empty", "Command::stepId is empty", Command) if not Command.stepId
  throw new Meteor.Error("Command:userId:empty", "Command::userId is empty", Command) if not Command.userId
  CommandPreSave.call(@, userId, Command)
  true

Commands.before.update (userId, Command, fieldNames, modifier, options) ->
  modifier.$set = modifier.$set or {}
  CommandPreSave.call(@, userId, modifier.$set)
  true
