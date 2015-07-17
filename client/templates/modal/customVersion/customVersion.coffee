Template.customVersion.helpers
#  helper: ->

Template.customVersion.onRendered ->
  @$("form").formValidation(
    framework: 'bootstrap'
    live: "disabled"
    fields:
      text:
        validators:
          notEmpty:
            message: 'Please enter your reason for custom version'
  ).on('success.form.fv', grab encapsulate (event) ->
      $form = $(event.currentTarget).closest("form") # ye olde IE
      parameters = {}
      for field in $form.serializeArray()
        parameters[field.name] = field.value
      $submit = $form.find("button[type='submit']")
      $submit.find(".ready").hide()
      $submit.find(".loading").show()
      Users.update(Meteor.userId(), {$addToSet: {flags: "InterestedInCustomVersion"}})
      Meteor.call("sendMeMail", "Custom API integration", parameters["text"], ->
        $submit.find(".ready").show()
        $submit.find(".loading").hide()
        alert("Thanks! I'll get in touch with you soon.")
        $(".modal").modal("hide")
      )
  )
  setTimeout ->
    @$("textarea").focus()
  , 1000

Template.customVersion.events
