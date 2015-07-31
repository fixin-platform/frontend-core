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
Commands.before.insert (userId, Command) ->
  params =
    workflowId: Command._id
  if Command.stepId
    step = Steps.findOne(Command.stepId, {transform: Transformations.Step})
    params.domain = step.domain
    params.workflowType = step.workflowType
    params.taskList = step.taskList
    params.input = JSON.stringify(step.input())
  else
    params.domain = Meteor.settings.swfDomain
    params.workflowType =
      name: Command.cls
      version: "1.0.0"
    params.taskList =
      name: Command.cls
    params.input = JSON.stringify(Command.params)
  data = startWorkflowExecutionSync(params)
  Command.runId = data.runId
  true

Commands.before.remove (userId, Command) ->
  requestCancelWorkflowExecutionSync(
    domain: Command.domain
    workflowId: Command._id
  )
  true
