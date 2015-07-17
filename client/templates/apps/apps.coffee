Session.setDefault("appsFilter", "")

Template.apps.helpers
  filter: -> Session.get("appsFilter")
  apps: ->
    selector = Pack.call("getAppsSelector") or {}
    filter = Session.get("appsFilter").trim()
    selector.name = new RegExp(RegExp.escape(filter), "i") if filter
    Apps.find(selector, {sort: {position: 1}})

Template.apps.onCreated ->
  Session.set("appsFilter", "")

Template.apps.onRendered ->
  @$("input").first().focus()

Template.apps.events
  "keyup .filter": (event, template) ->
    Session.set("appsFilter", $(event.currentTarget).val())
  "submit form": grab encapsulate (event, template) ->
    $link = template.$(".app").first()
    if $link.length
      Router.go($link.attr("href"))

