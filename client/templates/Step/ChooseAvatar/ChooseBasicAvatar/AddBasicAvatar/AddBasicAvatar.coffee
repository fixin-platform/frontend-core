Template.AddBasicAvatar.helpers
#  helper: ->

Template.AddBasicAvatar.onRendered ->
  step = @data
  @$("input").first().focus()
  @$("form").formValidation(
    framework: 'bootstrap'
    live: "disabled"
    fields:
      username:
        validators:
          notEmpty:
            message: "Please enter your #{step.api} username"
      password:
        validators:
          notEmpty:
            message: "Please enter your #{step.api} password"
  ).on('success.form.fv', grab encapsulate (event) ->
      $form = $(event.currentTarget).closest("form")
      $set = {}
      for field in $form.serializeArray()
        $set[field.name] = field.value
      # TODO call server method to add account
#      Steps.update(step._id, {$set: $set}, Foreach.handleError ->
#          $form.data("formValidation").resetForm()
#          $form[0].reset() # formValidation only resets the fields which have validators
#          $form.find(":input:visible").first().focus()
#      )
  )

Template.AddBasicAvatar.events
#  "click .selector": (event, template) ->
