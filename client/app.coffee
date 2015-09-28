t = (level = 0) -> Template.parentData(level) # level 0 is current template

# Issues with login popup, use routing instead
#Spire.requireLogin = ->
#  return false if Meteor.userId()
#  AccountsTemplates.setState("signIn");
#  $('#loginPopup').modal('show')
#  true

Spire.getParam = (key, context = Template.currentData() or {}) ->
  context[key] or FlowRouter.getParam(key)

Spire.showError = (error) ->
  if error instanceof Meteor.Error
    if error.error is 402 # Payment required
      Blaze.renderWithData(Template.modal,
        template: "greed"
        data: if error.details then EJSON.parse(error.details) else {} # error.details are action parameters
      , document.body)
      return
    message = error.message
  else
    message = error
  message = "Oh snap!\n\n#{message}"
  alert(message)
  if error instanceof Error
    throw error
  else
    throw new Error(error)

Spire.createErrback = (callback = null, callbackfinal = null) ->
  (error) ->
    if error
      Spire.showError(error)
    else
      callback?.apply(@, arguments)
    callbackfinal?.apply(@, arguments)
