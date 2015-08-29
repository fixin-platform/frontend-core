Template.Picker.helpers
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

