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
  step = Steps.findOne(command.stepId, {transform: Transformations.Step})
  input = step.input(command)
  _.defaults input,
    commandId: command._id
    stepId: step._id
    userId: step.userId
  params =
    domain: step.domain
    workflowId: command._id
    workflowType: step.workflowType
    taskList: step.taskList
    tagList: [ # unused for now, but helpful in debug
      command._id
      step._id
      step.userId
    ]
    input: JSON.stringify(input)
  console.log params
  data = startWorkflowExecutionSync(params)
  command.runId = data.runId
  true

Commands.before.remove (userId, command) ->
  step = Steps.findOne(command.stepId, {transform: Transformations.Step})
  params =
    domain: step.domain
    workflowId: command._id
  try
    requestCancelWorkflowExecutionSync(params)
  catch error
    throw error if error.code isnt "UnknownResourceFault" # Workflow execution may have already been terminated
  true
