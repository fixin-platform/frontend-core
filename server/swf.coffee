AWS = Npm.require "aws-sdk"

# [dev] Meteor.settings.swf.options -> ./settings-local/dev.json (developers have their own AWS SWF credentials)
# [prod] Meteor.settings.swf.options -> ./settings/prod.json (client supplies general-purpose credentials)
check Meteor.settings.swfDomain, String
check Meteor.settings.swf,
  accessKeyId: String
  secretAccessKey: String
  region: String

swf = new AWS.SWF _.extend
  apiVersion: "2012-01-25",
, Meteor.settings.swf
startWorkflowExecutionSync = Meteor.wrapAsync(swf.startWorkflowExecution, swf)
requestCancelWorkflowExecutionSync = Meteor.wrapAsync(swf.requestCancelWorkflowExecution, swf)

# Using "before" hook to ensure that SWF receives our request
Commands.before.insert (userId, command) ->
  params =
    workflowId: command._id
  if command.stepId
    step = Steps.findOne(command.stepId, {transform: Transformations.Step})
    input = step.input()
    _.defaults input,
      commandId: command._id
      stepId: step._id
      userId: step.userId
    params.domain = step.domain
    params.workflowType = step.workflowType
    params.taskList = step.taskList
    params.input = JSON.stringify(input)
  else
    params.domain = Meteor.settings.swfDomain
    params.workflowType =
      name: command.cls
      version: "1.0.0"
    params.taskList =
      name: command.cls
    params.input = JSON.stringify(command.params)
  data = startWorkflowExecutionSync(params)
  command.runId = data.runId
  true

Commands.before.remove (userId, command) ->
  requestCancelWorkflowExecutionSync(
    domain: command.domain
    workflowId: command._id
  )
  true
