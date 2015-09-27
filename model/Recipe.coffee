Transformations["Recipe"] = (object) -> Transformations.dynamic(Recipes, Recipes.Recipe, object)
Recipes = Collections["Recipe"] = new Mongo.Collection("Recipes", {transform: if Meteor.isClient then Transformations.Recipe else null})

class Recipes.Recipe
  constructor: (doc) ->
    _.extend(@, doc)
    @template ?= "Recipe"
  _i18n: -> i18n.t(@_i18nKey(), _.extend({returnObjectTrees: true}, @_i18nParameters()))
  _i18nKey: -> "Recipes.#{@cls}"
  _i18nParameters: -> {}
  displayName: -> @name
  generateSteps: -> throw "Implement #{@cls}::generateSteps method"
  # Don't forget to return true, otherwise the insert/update will be stopped!
  insertStep: (step) ->
    Steps.insert _.extend step,
      recipeId: @_id
      userId: @userId
  beforeInsert: (userId, Recipe) ->
    true
  afterInsert: (userId, Recipe) ->
    true
  beforeUpdate: (userId, Recipe, fieldNames, modifier, options) ->
    true
  afterUpdate: (userId, Recipe, fieldNames, modifier, options) ->
    true
  page: ->
    Pages.findOne({cls: "Landing", "options.recipe.cls": @cls})
  listUrl: ->
    "#{@page().url}/recipes"
  url: ->
    "#{@page().url}/recipes/#{@_id}"
  steps: (selector = {}, options = {}) ->
    Steps.find(_.extend({recipeId: @_id}, selector), options)
  stepsByKey: ->
    steps = {}
    for step in Steps.find({recipeId: @_id}).fetch()
      steps[step.key] = step
    steps
  stepByKey: (key) ->
    Steps.findOne({recipeId: @_id, key: key})
  createdAtFormatted: ->
    moment(@createdAt).format("YYYY-MM-DD HH:mm:ss")
  stepAfterUpdate: (userId, Step, fieldNames, modifier, options) ->
    # Need to add `hasBeenExecuted` to Step model
#    @steps({isAutorun: true}, {transform: Transformations.Step}).forEach (step) ->
#      step.tryToRun()
    true
  generateProgressBars: (activityIds, startedActivityIds, skippedActivityIds = []) ->
    # required for latency compensation
    {activityId: activityId, isSkipped: activityId in skippedActivityIds, isStarted: activityId in startedActivityIds, isCompleted: false, isFailed: false} for activityId in activityIds

Recipes.match = ->
  _id: Match.StringId
  name: String
  cls: String
  isAutorun: Boolean
  userId: Match.ObjectId(Users)
  updatedAt: Date
  createdAt: Date

RecipePreSave = (userId, changes) ->
  now = new Date()
  changes.updatedAt = changes.updatedAt or now

Recipes.before.insert (userId, Recipe) ->
  Recipe._id ||= Random.id()
  now = new Date()
  _.autovalues(Recipe,
    isAutorun: false
    userId: userId
    updatedAt: now
    createdAt: now
  )
  Recipe.name = autoname(Recipe)
  check Recipe, Recipes.match()
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

autoname = (Recipe) ->
  name = Transformations.Recipe(Recipe)._i18n().name
  if Meteor.isServer
    userId = Recipe.userId
    check(name, String)
    check(userId, Match.StringId)
    count = Recipes.find({ name: { $regex: "^" + name, $options: "i" }, userId: userId }).count()
    return "#{name} (#{count + 1})" if count
  return name

if Meteor.isServer
  Recipes.after.remove (userId, Recipe) ->
    Steps.remove({recipeId: Recipe._id})
