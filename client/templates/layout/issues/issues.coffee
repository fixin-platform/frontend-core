Template.issues.helpers
  issues: ->
    Issues.find({stepId: @_id}, {sort: {createdAt: 1}})

Template.issues.onCreated ->
  @subscribe("IssuesByStepId", @data._id)

Template.issues.events
#  "click .selector": (event, template) ->
