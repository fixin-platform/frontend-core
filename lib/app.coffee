Spire.stub = -> throw "Implement #{arguments.callee.caller.name}"

#Foreach.combine = (funcs...) ->
#  (args...) =>
#    for func in funcs
#      func.apply(@, args)

sanitizedProperties = ["credentials", "accessToken", "refreshToken", "expiresAt"]
sanitize = (object, references = []) ->
  if _.isFunction(object)
    result = object.toString()
  else if _.isObject(object)
    if object in references
      result = "$circular"
    else
      references.push(object)
      result = {}
      for key, value of object
        value = "*censored*" if key in sanitizedProperties
        cleanKey = key.replace(/\$/g, "_dollar_") # otherwise Mongo complains
        result[cleanKey] = sanitize(value, references)
  else if _.isArray(object)
    result = []
    for element, index in object
      result[index] = sanitize(element, references)
  else
    result = object
  result


partializedAccessor = (field, object) -> # argument order simplifies its usage with _.partial
  value = object[field]
  if _.isFunction(value)
    value.call(object)
  else
    value

Spire.minute = 60 * 1000
Spire.hour = 60 * Spire.minute

Spire.updateInterval = 5 * Spire.minute
Spire.pageLimit = 20

Spire.currentUser = (fields, userId = Meteor.userId()) ->
  Users.findOne(userId, {fields: fields})

Spire.currentUserReady = ->
  user = Spire.currentUser({createdAt: 1})
  !!(user and user.createdAt) # Built-in Meteor subscription sends only "username", "emails", "profile" fields; wait until our custom publication sends other fields

Spire.currentUserOption = (app, option) ->
  fields = {}
  fields["options.#{app}.#{option}"] = 1
  user = Spire.currentUser(fields)
  user.options[app]?[option]

createError = (e) ->
  error = {}
  if e instanceof Meteor.Error
    error = _.pick(e, "reason", "details")
  else
    error = {reason: e.message}
  _.defaults(error, reason: "", details: {})
  error.details = sanitize(error.details)
  error.details.stack ?= e.stack
  error.details.createdAt ?= new Date()
  error

Spire.MeteorPromisifier = (originalMethod) ->
  Promise.promisify(Meteor.bindEnvironment(originalMethod, null, @))
