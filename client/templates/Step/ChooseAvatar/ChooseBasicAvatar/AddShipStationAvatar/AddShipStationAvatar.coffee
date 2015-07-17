Template.AddShipStationAvatar.helpers
#  helper: ->
  options: ->
#    if AvatarSubscriptionIsInitialized.equals(@api, true)
    Avatars.find({api: @api})

Template.AddShipStationAvatar.onRendered ->
  step = @data
  @$("input").first().focus()
  @$("form").formValidation(
    framework: 'bootstrap'
    live: "disabled"
    fields:
      key:
        validators:
          notEmpty:
            message: "Please enter your #{step.api} API key"
      secret:
        validators:
          notEmpty:
            message: "Please enter your #{step.api} API secret"
  ).on('success.form.fv', grab encapsulate (event) ->
      $button = $(event.currentTarget)
      $button.find(".ready").hide()
      $button.find(".loading").show()

      $form = $(event.currentTarget).closest("form")
      values = {}
      for field in $form.serializeArray()
          values[field.name] = field.value

      Meteor.call("saveShipStationCredential", step._id, values.key, values.secret, (error, avatarId) ->
        $button.find(".ready").show()
        $button.find(".loading").hide()

        if ( ! error)
          step.execute({avatarId: avatarId})
      )
  )

Template.AddShipStationAvatar.events
#  "click .selector": (event, template) ->
