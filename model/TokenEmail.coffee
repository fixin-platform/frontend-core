Transformations["TokenEmail"] = (object) -> Transformations.static(TokenEmails.TokenEmail, object)
TokenEmails = Collections["TokenEmail"] = new Mongo.Collection("TokenEmails", {transform: if Meteor.isClient then Transformations.TokenEmail else null})

class TokenEmails.TokenEmail
  constructor: (doc) ->
    _.extend(@, doc)

TokenEmailPreSave = (userId, changes) ->
  now = new Date()
  changes.updatedAt = changes.updatedAt or now

TokenEmails.before.insert (userId, TokenEmail) ->
  TokenEmail._id ||= Random.id()
  now = new Date()
  _.autovalues(TokenEmail,
    email: ""
    userToken: currentUserToken or null
    updatedAt: now
    createdAt: now
  )
  TokenEmailPreSave.call(@, userId, TokenEmail)
  true

TokenEmails.before.update (userId, TokenEmail, fieldNames, modifier, options) ->
  modifier.$set = modifier.$set or {}
  TokenEmailPreSave.call(@, userId, modifier.$set)
  true

if Meteor.isClient
  TokenEmails.after.insert (userId, TokenEmail) ->
    mixpanel.track("TokenEmail", _.extend({userId: userId}, TokenEmail))
