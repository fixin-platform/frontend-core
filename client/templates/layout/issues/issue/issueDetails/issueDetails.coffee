Template.issueDetails.helpers
  formattedDetails: ->
    details = _.clone(@details)
    stack = if details.stack then details.stack + "\n\n" or ""
    delete details.stack
    stack + JSON.stringify(details, null, 2)
  subject: ->
    @reason
  body: ->
    """
      Hey Denis, I found a bug. Here are some details:

      #{Template.issueDetails.__helpers.get("formattedDetails").apply(@, arguments)}
    """

Template.issueDetails.onRendered ->

Template.issueDetails.events
#  "click .selector": (event, template) ->
