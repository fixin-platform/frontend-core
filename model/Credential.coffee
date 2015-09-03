Transformations["Credential"] = (object) -> Transformations.static(Credentials.Credential, object)
Credentials = Collections["Credential"] = new Mongo.Collection("Credentials", {transform: if Meteor.isClient then Transformations.Credential else null})

class Credentials.Credential
  constructor: (doc) ->
    _.extend(@, doc)
  Avatar: ->
    Avatars.findOne(@avatarId)

Credentials.match = ->
  _id: Match.StringId
  api: String
  scopes: [String]
  details: Match.ObjectIncluding
    # mandatory for OAuth credentials, optional for Basic credentials
    accessToken: Match.Optional(String)
    refreshToken: Match.Optional(String)
    expiresAt: Match.Optional(Date)
  userId: Match.ObjectId(Users)
  updatedAt: Date
  createdAt: Date

CredentialPreSave = (userId, changes) ->
  now = new Date()
  changes.updatedAt = changes.updatedAt or now

Credentials.before.insert (userId, Credential) ->
  Credential._id ||= Random.id()
  now = new Date()
  _.autovalues(Credential,
    scopes: []
    details: {}
    updatedAt: now
    createdAt: now
  )
  check Credential, Credentials.match()
  CredentialPreSave.call(@, userId, Credential)
  true

Credentials.before.update (userId, Credential, fieldNames, modifier, options) ->
  modifier.$set = modifier.$set or {}
  CredentialPreSave.call(@, userId, modifier.$set)
  true
