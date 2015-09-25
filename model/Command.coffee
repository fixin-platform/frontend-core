Transformations["Command"] = (object) -> Transformations.static(Commands.Command, object)
Commands = Collections["Command"] = new Mongo.Collection("Commands", {transform: if Meteor.isClient then Transformations.Command else null})

class Commands.Command
  constructor: (doc) ->
    _.extend(@, doc)
  step: ->
    Steps.findOne(@stepId)

Commands.match = ->
  _id: Match.StringId
  progressBars: [ # at least one progress bar must be present
    activityId: String
    isSkipped: Boolean
    isStarted: Boolean
    isCompleted: Boolean
    isFailed: Boolean
  ]
  isStarted: Boolean
  isCompleted: Boolean
  isFailed: Boolean
  isDryRun: Boolean
  isShallow: Boolean
  isDryRunWorkflowExecution: Boolean
  sampleId: Match.Optional(Match.StringId) # Match.Optional(Match.ObjectId(Samples))
  stepId: Match.ObjectId(Steps)
  userId: Match.ObjectId(Users)
  updatedAt: Date
  createdAt: Date

CommandPreSave = (userId, changes) ->
  now = new Date()
  changes.updatedAt = changes.updatedAt or now

Commands.before.insert (userId, Command) ->
  Command._id ||= Random.id()
  now = new Date()
  _.autovalues(Command,
    progressBars: []
    isStarted: false
    isCompleted: false
    isFailed: false
    isDryRun: true # POST/PUT/DELETE and also "GET/HEAD with side-effects" are disallowed
    isShallow: false # with task hierarchy
    isDryRunWorkflowExecution: Meteor.settings.public.isDryRunWorkflowExecution
    userId: userId
    updatedAt: now
    createdAt: now
  )
  check Command, Commands.match()
  CommandPreSave.call(@, userId, Command)
  true

Commands.before.update (userId, Command, fieldNames, modifier, options) ->
  modifier.$set = modifier.$set or {}
  CommandPreSave.call(@, userId, modifier.$set)
  true
