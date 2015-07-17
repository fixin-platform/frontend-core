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
