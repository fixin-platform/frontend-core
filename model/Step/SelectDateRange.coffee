class Steps.SelectDateRange extends Steps.Step
  template: "SelectDateRange"
  constructor: (config) ->
    super
  execute: (values) ->
    $set = _.extend(
      isCompleted: true
    , values)
    Steps.update(@_id, {$set: $set})
  revert: ->
    $set =
      isCompleted: false
    $unset =
      dateFrom: 1
      dateTo: 1
    Steps.update(@_id, {$set: $set, $unset: $unset})
  _i18nParameters: ->
    dateFrom: @dateFrom
    dateTo: @dateTo
