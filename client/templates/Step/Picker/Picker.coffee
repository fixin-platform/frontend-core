Template.Picker.helpers
  isMessageLoading: ->
    message = Messages.findOne({type: "load", recipe: @cls}, {fields: {status: 1}})
    message and message.status is "loading"
  isSubscriptionLoading: ->
    not StepSubscriptions[@_id].ready()
  isCredentialRequired: ->
    # TODO: use Avatars
#    api: fields.api,
    fields = @credentialFields()
    fields and not Credentials.findOne({scopes: {$all: fields.scopes}})
  count: ->
    Counts.get("RowsCountByStepId")
  columns: ->
    # make it work independently of context
    Template.instance().data.step.columns({sort: {position: 1}})
  rows: ->
    Rows.find({stepId: @_id}, {sort: {orderDate: -1}})
  columnData: ->
    {
      column: Template.parentData(0)
      row: Template.parentData(1)
      step: Template.parentData(2)
    }
  message: ->
    Messages.findOne({type: "load", recipe: @cls}, {fields: {errors: 1}})

Template.Picker.onCreated ->
  stepId = @data.stepId
  @subscribe("RowsCountByStepId", stepId)
  @subscribe("Columns", stepId)
  @subscribe("Filters", stepId)
  StepSubscriptions[stepId] = @subscribe("RowsByStepId", stepId,
    onStop: ->
      delete StepSubscriptions[stepId]
  )

Template.Picker.events
  "click .refresh": grab encapsulate (event, template) ->
    Spire.sendMessageWithoutDuplicates({type: "load", recipe: @cls}, {type: "load", recipe: @cls, stepId: @_id, filter: {storeId: Meteor.settings.public.Pillomatic.storeId, orderDateStart: "2015-04-01"}})
  "click .cancel-refresh": grab encapsulate (event, template) ->
    message = Messages.findOne({type: "load", recipe: @cls})
    Messages.remove(message._id) if message

