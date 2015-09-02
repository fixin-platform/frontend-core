Template.issues.helpers
  issues: ->
    @issues({}, {sort: {createdAt: -1}})

Template.issues.onCreated ->
  @autorun =>
    currentData = Template.currentData()
    @subscribe("IssuesByStepId", currentData._id)

Template.issues.events
#  "click .selector": (event, template) ->
