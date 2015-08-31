t = (level = 0) -> Template.parentData(level) # level 0 is current template

Spire.requireLogin = ->
  return false if Meteor.userId()
  AccountsTemplates.setState("signUp");
  $('#loginPopup').modal('show')
  true

Spire.getParam = (key, context = Template.currentData()) ->
  context[key] or FlowRouter.getParam(key)

Spire.showError = (error) ->
  message = "Oh snap!\n\n"
  if error instanceof Meteor.Error
    message += error.message
  else
    message += error
  alert(message)
  if error instanceof Error
    throw error
  else
    throw new Error(error)

Spire.handleError = (callback = null, callbackfinal = null) ->
  (error) ->
    if error
      Spire.showError(error)
    else
      callback?.apply(@, arguments)
    callbackfinal?.apply(@, arguments)
