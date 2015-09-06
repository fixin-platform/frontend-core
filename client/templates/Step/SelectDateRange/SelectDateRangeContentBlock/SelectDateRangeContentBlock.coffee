#  execute: (values) ->
#    $set = _.extend(
#      isCompleted: true
#    , values)
#    Steps.update(@_id, {$set: $set})
#  revert: ->
#    $set =
#      isCompleted: false
#    $unset =
#      dateFrom: 1
#      dateTo: 1
#    Steps.update(@_id, {$set: $set, $unset: $unset})
#  _i18nParameters: ->
#    dateFrom: @dateFrom
#    dateTo: @dateTo

Template.SelectDateRangeContentBlock.onRendered ->
  $(".step form:not(.self-validation)").formValidation
    framework: "bootstrap"
    icon:
      valid: "fa fa-check"
      invalid: "fa fa-remove"
      validating: "fa fa-refresh"
    fields:
      dateFrom:
        validators:
          notEmpty: {}
          date:
            format: 'MM/DD/YYYY'
            max: "dateTo"
        onSuccess: (e, data) ->
          unless data.fv.isValidField("dateTo")
            data.fv.revalidateField("dateTo")
      dateTo:
        validators:
          notEmpty: {}
          date:
            format: 'MM/DD/YYYY'
            min: "dateFrom"
        onSuccess: (e, data) ->
          unless data.fv.isValidField("dateFrom")
            data.fv.revalidateField("dateFrom")
