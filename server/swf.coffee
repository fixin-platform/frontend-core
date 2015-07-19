AWS = Npm.require "aws-sdk"

# [dev] Meteor.settings.swf.options -> ./settings-local/dev.json (developers have their own AWS SWF credentials)
# [prod] Meteor.settings.swf.options -> ./settings/prod.json (client supplies general-purpose credentials)
check Meteor.settings.swf.options,
  accessKeyId: String
  secretAccessKey: String
  region: String
check Meteor.settings.swf.domain, String

swf = new AWS.SWF _.extend
  apiVersion: "2012-01-25",
, Meteor.settings.swf.options
swf.startWorkflowExecutionSync = Meteor.wrapAsync(swf.startWorkflowExecution, swf)

# Using "before" hook to ensure that SWF receives our request
Commands.before.insert (userId, Command) ->
  step = Steps.findOne(Command.stepId, {transform: Transformations.Step})
  console.log step
  swf.startWorkflowExecutionSync(
    domain: Meteor.settings.swf.domain
    workflowId: Command._id
    workflowType:
      name: step.cls
      version: step.version or "1.0.0"
    taskList:
      name: step.cls
    input: JSON.stringify step.input()
  )
  true