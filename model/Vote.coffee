Transformations["Vote"] = (object) -> Transformations.static(Votes.Vote, object)
Votes = Collections["Vote"] = new Mongo.Collection("Votes", {transform: if Meteor.isClient then Transformations.Vote else null})

class Votes.Vote
  constructor: (doc) ->
    _.extend(@, doc)

VotePreSave = (userId, changes) ->
  now = new Date()
  changes.updatedAt = changes.updatedAt or now

Votes.before.insert (userId, Vote) ->
  Vote._id ||= Random.id()
  now = new Date()
  _.autovalues(Vote,
    app: ""
    action: ""
    userId: userId
    userToken: currentUserToken or null
    updatedAt: now
    createdAt: now
  )
  VotePreSave.call(@, userId, Vote)
  true

Votes.before.update (userId, Vote, fieldNames, modifier, options) ->
  modifier.$set = modifier.$set or {}
  VotePreSave.call(@, userId, modifier.$set)
  true

if Meteor.isClient
  Votes.after.insert (userId, Vote) ->
    mixpanel.track("Vote", _.extend({userId: userId}, Vote))
