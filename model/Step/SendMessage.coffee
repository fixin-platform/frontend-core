class Steps.SendMessage extends Steps.Step
  template: "SendMessage"
  constructor: (config) ->
    check config, Match.ObjectIncluding
      selector: Function
    super
  isCompleted: ->
    @field("status") is "success"
  hasErrors: ->
    @errors().length
  errors: ->
    @field("errors", [])
  field: (field, defaultValue = null) ->
    message = @message()
    return defaultValue if not message
    message[field]
  execute: ->
    Foreach.sendMessageWithoutDuplicates(@selector(), @selector())
  revert: ->
    message = @message()
    Messages.remove(message._id) if message
  message: ->
#    GoogleDriveFiles.findOne().alternateLink
    Messages.findOne(@selector())
