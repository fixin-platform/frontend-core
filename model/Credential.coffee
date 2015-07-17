Transformations["Credential"] = (object) -> Transformations.static(Credentials.Credential, object)
Credentials = Collections["Credential"] = new Mongo.Collection("Credentials", {transform: if Meteor.isClient then Transformations.Credential else null})

class Credentials.Credential
  constructor: (doc) ->
    _.extend(@, doc)
  Avatar: ->
    Avatars.findOne(@avatarId)

CredentialPreSave = (userId, changes) ->
  now = new Date()
  changes.updatedAt = changes.updatedAt or now

Credentials.before.insert (userId, Credential) ->
  Credential._id ||= Random.id()
  now = new Date()
  _.defaults(Credential,
    scopes: []
    details: {}
    updatedAt: now
    createdAt: now
  )
  CredentialPreSave.call(@, userId, Credential)
  true

Credentials.before.update (userId, Credential, fieldNames, modifier, options) ->
  modifier.$set = modifier.$set or {}
  CredentialPreSave.call(@, userId, modifier.$set)
  true
