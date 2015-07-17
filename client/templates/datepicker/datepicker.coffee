Template.datepicker.helpers
#  helper: ->

Template.datepicker.onRendered ->
  $input = @$("input")
  $input.datepicker
    changeMonth: true
    changeYear: true
    dateFormat: "mm/dd/yy"
    onSelect: (value, datepicker) ->
      # Revalidate the date field
      $field = $(@)
      $form = $field.closest("form")
      if $form.length and $form.formValidation
        $form.formValidation("revalidateField", $field.attr("name"))

Template.datepicker.events
#  "click .selector": (event, template) ->
