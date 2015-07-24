Transformations["App"] = (object) -> Transformations.static(Apps.App, object)
Apps = Collections["App"] = new Mongo.Collection("Apps", {transform: if Meteor.isClient then Transformations.App else null})

class Apps.App
  constructor: (doc) ->
    _.extend(@, doc)
  blueprints: ->
    Blueprints.find({appId: @_id}, {sort: {position: 1}})
  url: ->
    "/" + @key

AppPreSave = (userId, changes) ->
  now = new Date()
  changes.updatedAt = changes.updatedAt or now

Apps.before.insert (userId, App) ->
  App._id ||= Random.id()
  now = new Date()
  LastApp = Apps.findOne({}, {sort: {position: -1}})
  _.defaults(App,
    position: if LastApp then LastApp.position + 1 else 1
    userId: userId
    updatedAt: now
    createdAt: now
  )
  AppPreSave.call(@, userId, App)
  true

Apps.before.update (userId, App, fieldNames, modifier, options) ->
  modifier.$set = modifier.$set or {}
  AppPreSave.call(@, userId, modifier.$set)
  true
