Template.ChooseAvatar.helpers
  options: ->
#    if AvatarSubscriptionIsInitialized.equals(@api, true)
      avatarIds = _.pluck(Credentials.find({api: @api, scopes: {$all: @scopes}}).fetch(), "avatarId")
      Avatars.find({api: @api, _id: {$in: avatarIds}})

Template.ChooseAvatar.onCreated ->
  # TODO: is that subscription stopped when the template is destroyed?
#  if not AvatarSubscriptionIsInitialized.equals(@data.api, true) # TODO or subscription.stopped()
    @subscribe("Avatars", @data.api)
    @subscribe("Credentials", @data.api)
#    AvatarSubscriptionIsInitialized.set(@data.api, true)

Template.ChooseAvatar.onDestroyed ->

Template.ChooseAvatar.events
  "click .add": grab encapsulate (event, template) ->
    switch @type
      when "form"
        Steps.update(@_id, {$set: {isAddTemplateMode: true}})
      when "connect"
        connect(@api, @scopes, Spire.handleError => @callback.apply(@, arguments))
      else
        throw "Unknown type \"#{@type}\""
  "click .cancel-add": grab encapsulate (event, template) ->
    switch @type
      when "form"
        Steps.update(@_id, {$set: {isAddTemplateMode: false}})
