defaultTemplateName = (name, suffix) -> if Template[name + suffix] then name + suffix else "DefaultStep" + suffix

Template.ManagedStep.helpers
  isCompletedTemplateName: -> defaultTemplateName(@name, "IsCompleted")
  isActiveTemplateName: -> defaultTemplateName(@name, "IsActive")
  isPendingTemplateName: -> defaultTemplateName(@name, "IsPending")

Template.ManagedStep.onCreated ->

Template.ManagedStep.events
#  "click .selector": (event, template) ->
