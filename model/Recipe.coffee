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
  generateStep: (selector, modifier, callback) ->
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
    Steps.insert(object, callback)
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
  Recipe.name = autoname(Recipe)
  now = new Date()
  _.autovalues(Recipe,
    isAutorun: false
    userId: userId
    updatedAt: now
    createdAt: now
  )
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

Recipes.after.remove (userId, Recipe) -> Steps.remove({recipeId: Recipe._id})

autoname = (Recipe) ->
  name = Transformations.Recipe(Recipe)._i18n().name
  if Meteor.isServer
    count = Recipes.find({ name: { $regex: "^" + name, $options: "i" } }).count()
    return "#{name} (#{count + 1})" if count
  return name
