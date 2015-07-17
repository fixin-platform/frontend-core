Pack =
  set: (name, property, value) ->
    @[name] ?= {}
    @[name][property] = value
  call: (method, args...) ->
    @get(method)?(args...)
  get: (property, defaultValue) ->
    @[Meteor.settings.public.pack]?[property] or defaultValue
  name: Meteor.settings.public.pack
  isApplied: !!Meteor.settings.public.pack
