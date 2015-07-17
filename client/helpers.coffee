UI.registerHelper "subscriptionsReady", ->
  Template.instance().subscriptionsReady()

UI.registerHelper "Foreach", ->
  Foreach

UI.registerHelper "Settings", ->
  Meteor.settings

UI.registerHelper "Router", ->
  Router

UI.registerHelper "Pack", ->
  Pack

UI.registerHelper "Session", (key) ->
  Session.get(key)

UI.registerHelper "SessionEquals", (key, value) ->
  Session.equals(key, value)

UI.registerHelper "currentAdapter", ->
  AdapterFactory.current

UI.registerHelper "currentUserReady", ->
  Foreach.currentUserReady()

UI.registerHelper "currentUserIsEditor", ->
  Meteor.user() and (UI._globalHelpers.currentUserField.call(@, "isEditor") or UI._globalHelpers.currentUserField.call(@, "isAdmin"))

UI.registerHelper "currentUserField", (field) ->
  fields = {}
  fields[field] = 1
  Foreach.currentUser(fields)[field]

UI.registerHelper "currentUserFlags", ->
  UI._globalHelpers.currentUserField.call(@, "flags")

UI.registerHelper "currentUserPlan", ->
  _.findWhere(Foreach.plans, {_id: UI._globalHelpers.currentUserField.call(@, "planId")})

UI.registerHelper "currentUserPlanActionsLeft", ->
  currentUserPlan = UI._globalHelpers.currentUserPlan.call(@)
  Math.max(0, Foreach.currentUser({"actions": 1}).actions + currentUserPlan.limit)

UI.registerHelper "condition", (v1, operator, v2, options) ->
  switch operator
    when "==", "eq", "is"
      v1 is v2
    when "!=", "neq", "isnt"
      v1 isnt v2
    when "===", "ideq"
      v1 is v2
    when "!==", "nideq"
      v1 isnt v2
    when "&&", "and"
      v1 and v2
    when "||", "or"
      v1 or v2
    when "<", "lt"
      v1 < v2
    when "<=", "lte"
      v1 <= v2
    when ">", "gt"
      v1 > v2
    when ">=", "gte"
      v1 >= v2
    when "in"
      v2 = if _.isArray(v2) then v2 else Array.prototype.slice.call(arguments, 2, arguments.length - 1)
      v1 in v2
    when "not in", "nin"
      v2 = if _.isArray(v2) then v2 else Array.prototype.slice.call(arguments, 2, arguments.length - 1)
      v1 not in v2
    else
      throw "Undefined operator \"" + operator + "\""

UI.registerHelper "not", (value) ->
  not value

UI.registerHelper "arrayify", (object) ->
  for key, value of object
    key: key
    value: value

UI.registerHelper "momentFromNow", (date) ->
  moment(date).fromNow()

UI.registerHelper "encodeURIComponent", (value) ->
  encodeURIComponent(value)

UI.registerHelper "currentUserEmail", ->
  Meteor.user().emails[0].address

UI.registerHelper "currentUrl", ->
  location.protocol + "//" + location.hostname + (if location.port then ':' + location.port else '') + Iron.Location.get().path

UI.registerHelper "moment", (date, format) ->
  moment(date).format(format)

UI.registerHelper "_", (key, hash) ->
  params = {} # default
  params = hash.hash  if hash
  result = i18n.t(key, params)
  new Spacebars.SafeString(result)

UI.registerHelper "isEmpty", (object, hash) ->
  _.isEmpty(object)

UI.registerHelper "lcfirst", (str) ->
  str.charAt(0).toLowerCase() + str.substr(1)

UI.registerHelper "percent", (value) ->
  value * 100

UI.registerHelper "nl2br", (text) ->
  nl2br = (text + "").replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, "$1" + "<br>" + "$2")
  new Spacebars.SafeString(nl2br)

UI.registerHelper "cl", ->
  cl.apply(window, arguments)
