Foreach.price = 0.01
Foreach.plans = [
  _id: "free"
  name: "free"
  limit: 100
  price: false
,
  _id: "gratis"
  name: "Gratis"
  limit: false
  price: false
,
  _id: "basic5"
  name: "Basic"
  limit: 500
  price: 5
  period: "month"
  periodShorthand: "mo"
  features: [
    "<strong>500</strong> actions/month"
    "All actions included"
    "Email support"
  ]
  alternativeProposition: "get <strong>1 month free</strong> with yearly plan"
  alternativeId: "basic5_yearly"
,
  _id: "basic5_yearly"
  name: "Basic Yearly"
  limit: 500
  price: 55
  period: "year"
  periodShorthand: "yr"
  features: [
    "<strong>500</strong> actions/month"
    "All actions included"
    "Email support"
    "<span class='fa fa-fw fa-diamond'></span> <strong>1 month free</strong>"
  ]
  alternativeProposition: "also available monthly"
  alternativeId: "basic5"
,
  _id: "business20"
  name: "Business"
  limit: false
  price: 20
  period: "month"
  periodShorthand: "mo"
  features: [
    "<strong>Unlimited</strong> actions/month"
    "All actions included"
    "<span class='fa fa-fw fa-phone'></span> <strong>Phone support</strong>"
  ]
  showPhone: true
  alternativeProposition: "get <strong>2 months free</strong> with yearly plan"
  alternativeId: "business20_yearly"
,
  _id: "business20_yearly"
  name: "Business Yearly"
  limit: false
  price: 200
  period: "year"
  periodShorthand: "yr"
  features: [
    "<strong>Unlimited</strong> actions/month"
    "All actions included"
    "<span class='fa fa-fw fa-phone'></span> <strong>Phone support</strong>"
    "<span class='fa fa-fw fa-diamond'></span> <strong>2 months free</strong>"
  ]
  showPhone: true
  alternativeProposition: "also available monthly"
  alternativeId: "business20"
]

Foreach.stub = -> throw "Implement #{arguments.callee.caller.name}"

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

Foreach.minute = 60 * 1000
Foreach.hour = 60 * Foreach.minute

Foreach.updateInterval = 5 * Foreach.minute
Foreach.pageLimit = 20

Foreach.currentUser = (fields, userId = Meteor.userId()) ->
  Users.findOne(userId, {fields: fields})

Foreach.currentUserReady = ->
  user = Foreach.currentUser({createdAt: 1})
  !!(user and user.createdAt) # Built-in Meteor subscription sends only "username", "emails", "profile" fields; wait until our custom publication sends other fields

Foreach.currentUserOption = (app, option) ->
  fields = {}
  fields["options.#{app}.#{option}"] = 1
  user = Foreach.currentUser(fields)
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

Foreach.MeteorPromisifier = (originalMethod) ->
  Promise.promisify(Meteor.bindEnvironment(originalMethod, null, @))
