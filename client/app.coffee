t = (level = 0) -> Template.parentData(level) # level 0 is current template

Foreach.getParam = (key, context = Template.currentData()) ->
  context[key] or FlowRouter.getParam(key)

Foreach.showError = (error) ->
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

Foreach.handleError = (callback = null, callbackfinal = null) ->
  (error) ->
    if error
      Foreach.showError(error)
    else
      callback?.apply(@, arguments)
    callbackfinal?.apply(@, arguments)
