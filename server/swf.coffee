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
swf.startWorkflowExecutionSync = Meteor.wrapAsync(swf.startWorkflowExecution, swf)

# Using "before" hook to ensure that SWF receives our request
Commands.before.insert (userId, Command) ->
  step = Steps.findOne(Command.stepId, {transform: Transformations.Step})
  swf.startWorkflowExecutionSync(
    domain: step.domain
    workflowId: Command._id
    workflowType: step.workflowType
    taskList: step.taskList
    input: JSON.stringify step.input()
  )
  true