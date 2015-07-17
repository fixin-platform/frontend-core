Transformations["Blueprint"] = (object) -> Transformations.static(Blueprints.Blueprint, object)
Blueprints = Collections["Blueprint"] = new Mongo.Collection("Blueprints", {transform: if Meteor.isClient then Transformations.Blueprint else null})

class Blueprints.Blueprint
  constructor: (doc) ->
    _.extend(@, doc)
  generateRecipe: (defaults, callback) ->
    recipeId = Recipes.insert _.defaults
      name: @name
      cls: @cls
      icon: @icon
      blueprintId: @_id
    , defaults
    recipe = Recipes.findOne(recipeId, {transform: Transformations.Recipe})
    recipe.generateSteps()
    recipe
  app: ->
    Apps.findOne(@appId)
  recipes: ->
    Recipes.find({blueprintId: @_id}, {sort: {createdAt: 1, _id: 1}})
  url: ->
    "/" + @app().key + "/" + @key


BlueprintPreSave = (userId, changes) ->
  now = new Date()
  changes.updatedAt = changes.updatedAt or now

Blueprints.before.insert (userId, Blueprint) ->
  Blueprint._id ||= Random.id()
  now = new Date()
  LastAction = Blueprints.findOne({appId: Blueprint.appId}, {sort: {position: -1}})
  _.autovalues(Blueprint,
    position: if LastAction?.position then LastAction.position + 1 else 1
    icon: -> _.sample(["flag", "leaf", "cubes", "gift", "life-ring", "lightbulb-o", "magic", "music", "tasks", "trophy", "bookmark"])
    isImplemented: true
    userId: userId
    updatedAt: now
    createdAt: now
  )
  BlueprintPreSave.call(@, userId, Blueprint)
  true

Blueprints.before.update (userId, Action, fieldNames, modifier, options) ->
  modifier.$set = modifier.$set or {}
  BlueprintPreSave.call(@, userId, modifier.$set)
  true
