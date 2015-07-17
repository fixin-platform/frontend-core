Transformations["Message"] = (object) -> Transformations.static(Messages.Message, object)
Messages = Collections["Message"] = new Mongo.Collection("Messages", {transform: if Meteor.isClient then Transformations.Message else null})

class Messages.Message
  constructor: (doc) ->
    _.extend(@, doc)

MessagePreSave = (userId, changes) ->
  now = new Date()
  changes.updatedAt = changes.updatedAt or now

Messages.before.insert (userId, Message) ->
  Message._id ||= Random.id()
  now = new Date()
  _.defaults(Message,
    progress: 0
    status: "loading"
    errors: []
    userId: userId
    updatedAt: now
    createdAt: now
  )
  throw new Meteor.Error("Message:userId:empty", "Message::userId is empty", Message) if not Message.userId
  MessagePreSave.call(@, userId, Message)
  true

Messages.before.update (userId, Message, fieldNames, modifier, options) ->
  modifier.$set = modifier.$set or {}
  MessagePreSave.call(@, userId, modifier.$set)
  true

Foreach.sendMessageWithoutDuplicates = (selector, message) ->
  message = message or _.deepClone(selector)
  Messages.find(selector, {reactive: false}).forEach (duplicate) ->
    Messages.remove(duplicate._id)
  Messages.insert(message)
