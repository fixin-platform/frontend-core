Transformations["Avatar"] = (object) -> Transformations.static(Avatars.Avatar, object)
Avatars = Collections["Avatar"] = new Mongo.Collection("Avatars", {transform: if Meteor.isClient then Transformations.Avatar else null})

class Avatars.Avatar
  constructor: (doc) ->
    _.extend(@, doc)
  credentials: ->
    Credentials.find({avatarId: @_id}, {sort: {position: 1}})

AvatarPreSave = (userId, changes) ->
  now = new Date()
  changes.updatedAt = changes.updatedAt or now

Avatars.before.insert (userId, Avatar) ->
  Avatar._id ||= Random.id()
  now = new Date()
  _.defaults(Avatar,
    imageUrl: ""
    details: {}
    userId: userId
    updatedAt: now
    createdAt: now
  )
  AvatarPreSave.call(@, userId, Avatar)
  true

Avatars.before.update (userId, Avatar, fieldNames, modifier, options) ->
  modifier.$set = modifier.$set or {}
  AvatarPreSave.call(@, userId, modifier.$set)
  true

Avatars.after.remove (userId, Avatar) ->
  Credentials.remove({avatarId: Avatar._id})
