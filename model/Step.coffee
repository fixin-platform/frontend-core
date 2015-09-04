Transformations["Step"] = (object) -> Transformations.dynamic(Steps, Steps.Step, object)
Steps = Collections["Step"] = new Mongo.Collection("Steps", {transform: if Meteor.isClient then Transformations.Step else null})

# TODO: when removing the step, remove tasks associated with this step if they are not isDone

class Steps.Step
  constructor: (doc) ->
    _.extend(@, doc)
    @template or= @cls
    @i18nKey or= @cls
    @isSafe or= false # Step is considered "safe" if its Command execution doesn't overwrite or delete user data
  isCurrent: -> not @isCompleted and @isActive()
  isActive: -> not Steps.findOne({isCompleted: false, position: {$lt: @position}, recipeId: @recipeId})
  forAllNext: (callback) ->
# TODO: rewrite using dependency mechanics
    prev = @last
    while prev
      break if prev is @
      callback(prev)
      prev = prev.prev
  revertAllNext: ->
    @forAllNext (step) -> step.revert()
  changeAllNext: ->
    @forAllNext (step) -> step.change()
  execute: -> throw "Implement me!"
  revert: -> throw "Implement me!"
  change: -> Steps.update(@_id, {$set: {isCompleted: false}})
  input: (command) -> @recipe().input(@, command)
  progressBars: -> @recipe().progressBars(@)
  domain: ->
    Meteor.settings.swf.domain
  workflowType: ->
    name: @cls
    version: @version or "1.0.0"
  taskList: ->
    name: @cls
#  columns: -> throw "Implement me!"
  insertCommand: (data) ->
    Commands.insert _.extend {}, data, @insertCommandData()
  insertCommandData: ->
    stepId: @_id
    progressBars: @progressBars()
  columns: -> @tempColumns()
  tempColumns: ->
    row = Rows.findOne({stepId: @_id})
    availableColumnsKeys = if row then _.keys(row) else []
    for key in availableColumnsKeys
      new Columns.Column(
        key: key
        _i18n:
          name: key
      )
  cachedColumns: ->
    return @_cachedColumns if @_cachedColumns
    @_cachedColumns = @columns()

  #  columns: (options) ->
#    Columns.find({stepId: @_id}, options)

  recipe: (options = {}) -> # for reactivity
    options.fields.cls = 1 if options.fields # for Transformations
    options.transform ?= Transformations.Recipe
    Recipes.findOne(@recipeId, options)
  recipeField: (field, defaultValue = null) ->
    fields = {}
    fields[field] = 1
    recipe = @recipe({fields: fields})
    return defaultValue if not recipe
    recipe[field] or defaultValue
  issues: (selector, options) ->
    Issues.find(_.extend({stepId: @_id}, selector), options)
  _i18n: ->
    key = @_i18nKey()
    parameters = @_i18nParameters()
    result = i18n.t(key, _.extend({returnObjectTrees: true}, parameters))
    result = {} if result is key # i18n not found
    throw new Meteor.Error("_i18n:not-an-object", "", {result: result}) if not _.isObject(result)
    _.defaults(result, @_i18nDefaults())
  _i18nKey: -> "Steps.#{@i18nKey}"
  _i18nParameters: -> {}
  _i18nDefaults: ->
    run: "run now"
    running: "running"
    cancel: "cancel"
    test: "test"
  credentialFields: -> null
  filters: (options) ->
    Filters.find({stepId: @_id}, options)
  app: ->
    Apps.findOne(@appId)
  url: ->
    "/steps/" + @_id
  incomingPipes: ->
    Pipes.find({destinationStepId: @_id})
  outgoingPipes: ->
    Pipes.find({sourceStepId: @_id})

# Don't forget to return true, otherwise the insert/update will be stopped!
Steps.Step::beforeInsert = (userId, Step) ->
  true
Steps.Step::afterInsert = (userId, Step) ->
  true
Steps.Step::beforeUpdate = (userId, Step, fieldNames, modifier, options) ->
  true
Steps.Step::afterUpdate = (userId, Step, fieldNames, modifier, options) ->
  true

# Step defaults have been moved to Recipe methods
#
#Steps.PreSave = (userId, changes) ->
#  now = new Date()
#  changes.updatedAt = changes.updatedAt or now
#
#Steps.before.insert (userId, Step) ->
#  throw new Meteor.Error("Step:userId:empty", "Step::userId is empty", Step) if not Step.userId
#  Steps.PreSave.call(@, userId, Step)
#  true
#
#Steps.before.update (userId, Step, fieldNames, modifier, options) ->
#  modifier.$set = modifier.$set or {}
#  Steps.PreSave.call(@, userId, modifier.$set)
#  true

Steps.before.insert (userId, Step) -> Transformations.cls(Steps, Steps.Step, Step)::beforeInsert.apply(@, arguments)

Steps.after.insert (userId, Step) -> Transformations.cls(Steps, Steps.Step, Step)::afterInsert.apply(@, arguments)

Steps.before.update (userId, Step, fieldNames, modifier, options) -> Transformations.cls(Steps, Steps.Step, Step)::beforeUpdate.apply(@, arguments)

Steps.after.update (userId, Step, fieldNames, modifier, options) -> Transformations.cls(Steps, Steps.Step, Step)::afterUpdate.apply(@, arguments)

Steps.after.remove (userId, Step) ->
  # removing one by one is better, because 1) It works on client 2) It runs hooks
  Step = Transformations.Step(Step)
  Step.filters().forEach (filter) ->
    Filters.remove(filter._id)
  Rows.remove({stepId: Step._id})
  Columns.remove({stepId: Step._id})
