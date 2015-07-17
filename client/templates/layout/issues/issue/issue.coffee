Template.issue.helpers
#  helper: ->

Template.issue.onRendered ->

Template.issue.events
  "click .show-details": grab encapsulate (event, template) ->
    Blaze.renderWithData(Template.modal,
      template: "issueDetails"
      data: @
    , document.body)
  "click .remove": grab encapsulate (event, template) ->
    Issues.remove(@_id)
