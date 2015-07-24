Transformations["Recipe"] = (object) -> Transformations.dynamic(Recipes, Recipes.Recipe, object)
Recipes = Collections["Recipe"] = new Mongo.Collection("Recipes", {transform: if Meteor.isClient then Transformations.Recipe else null})

class Recipes.Recipe
  constructor: (doc) ->
    _.extend(@, doc)
  _i18n: -> i18n.t(@_i18nKey(), _.extend({returnObjectTrees: true}, @_i18nParameters()))
  _i18nKey: -> "recipes.#{@name}"
  _i18nParameters: -> {}
  generateSteps: -> throw "Implement #{@cls}::generateSteps method"
  refreshTasks: -> throw "Implement #{@cls}::refreshTasks method"
  params: (steps) -> throw "Implement #{@cls}::params method"
  # Don't forget to return true, otherwise the insert/update will be stopped!
  beforeInsert: (userId, Recipe) ->
    true
  afterInsert: (userId, Recipe) ->
    true
  beforeUpdate: (userId, Recipe, fieldNames, modifier, options) ->
    true
  afterUpdate: (userId, Recipe, fieldNames, modifier, options) ->
    true
  blueprint: ->
    Blueprints.findOne(@blueprintId)
  url: ->
    @blueprint().url() + "/" + @_id
  steps: ->
    Steps.find({recipeId: @_id}, {sort: {position: 1}})
  stepsByKey: ->
    steps = {}
    for step in Steps.find({recipeId: @_id}).fetch()
      steps[step.key] = step
    steps
  stepByKey: (key) ->
    Steps.findOne({recipeId: @_id, key: key})
  createdAtFormatted: ->
    moment(@createdAt).format("YYYY-MM-DD HH:mm:ss")
  generateStep: (selector, modifier, options) ->
    check selector, Match.ObjectIncluding
      key: String
    selector.recipeId = @_id
    check modifier, Match.ObjectIncluding
      $set: Match.ObjectIncluding
        position: Match.Integer
    now = new Date()
    selector.userId = @userId
    modifier.$setOnInsert ?= {}
    _.defaults(modifier.$setOnInsert,
      _id: Random.id()
      search: ""
      page: 1
      hiddenColumnKeys: []
      isCompleted: false
      isDryRun: true
      isAutorun: false
      createdAt: now
    )
    modifier.$set ?= {}
    _.defaults(modifier.$set,
      updatedAt: now
    )
    check(modifier, # Ensure that old code is fully covered by BC
      $set: Match.Optional(Object)
      $setOnInsert: Match.Optional(Object)
    )
    object = _.extend({}, selector, modifier.$setOnInsert, modifier.$set)
    Steps.insert(object, options)
  requirementDefaults: (defaults) ->
    _.pick(defaults, "commandId", "stepId", "userId")


RecipePreSave = (userId, changes) ->
  now = new Date()
  changes.updatedAt = changes.updatedAt or now

Recipes.before.insert (userId, Recipe) ->
  Recipe._id ||= Random.id()
  now = new Date()
  _.defaults(Recipe,
    cls: ""
    appId: ""
    blueprintId: ""
    userId: userId
    isAutorun: false
    updatedAt: now
    createdAt: now
  )
  throw new Meteor.Error("Recipe:userId:empty", "Recipe::userId is empty", Recipe) if not Recipe.userId
  RecipePreSave.call(@, userId, Recipe)
  true

Recipes.before.update (userId, Recipe, fieldNames, modifier, options) ->
  modifier.$set = modifier.$set or {}
  RecipePreSave.call(@, userId, modifier.$set)
  true

Recipes.before.insert (userId, Recipe) -> Recipes[Recipe.cls]::beforeInsert.apply(@, arguments)

Recipes.after.insert (userId, Recipe) -> Recipes[Recipe.cls]::afterInsert.apply(@, arguments)

Recipes.before.update (userId, Recipe, fieldNames, modifier, options) -> Recipes[Recipe.cls]::beforeUpdate.apply(@, arguments)

Recipes.after.update (userId, Recipe, fieldNames, modifier, options) -> Recipes[Recipe.cls]::afterUpdate.apply(@, arguments)

Recipes.after.remove (userId, Recipe) -> Steps.remove({recipeId: Recipe._id})

if Meteor.isServer
  Recipes.after.remove (userId, Recipe) ->
    throw new Error("remove all Recipe tasks here")
