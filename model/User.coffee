class User
  constructor: (doc) ->
    _.extend(@, doc)
  email: ->
    @emails?[0]?.address
  name: ->
    @profile.name.replace(/\d/g, "")
  firstName: ->
    @name().split(' ').slice(0, 1).join(' ')
  lastName: ->
    @name().split(' ').slice(1).join(' ')
  plan: ->
    _.findWhere(Spire.plans, {_id: @planId})

Models.User = User
Transformations.User = _.partial(Transformations.static, User)

Users = Meteor.users
Collections.User = Users

if Meteor.isClient
  return # server-side code below

UserPreSave = (userId, changes) ->
  now = new Date()
  changes.updatedAt = changes.updatedAt or now

Users.before.insert (userId, user) ->
  _.autovalues(user,
    isNew: true
    planId: "free" # basic5, business20, basic5_yearly, business20_yearly
    executions: {}
    options: {}
    flags: []
  )
  UserPreSave.call(@, userId, user)
  true

Users.before.update (userId, user, fieldNames, modifier, options) ->
  modifier.$set = modifier.$set or {}
  if "profile.name" of modifier.$set
    modifier.$set["profile.isRealName"] = true
  UserPreSave.call(@, userId, modifier.$set)
  true

Users.after.update (userId, user, fieldNames, modifier, options) ->
  if user.isInternal or not user.isAliasedByMixpanel
    return true
  mixpanel.track_user(user)
  true
