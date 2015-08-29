Template.app.helpers
  app: ->
    Apps.findOne({key: Spire.getParam("appKey")})
  previewIcon: ->
    Session.get("blueprintIcon") or "heartbeat"
  userRecipes: ->
    Recipes.find({appId: @_id, isAutorun: false}, {sort: {createdAt: -1}})

Template.app.onCreated ->
  @subscribe("Recipes")

Template.app.onRendered ->
  @$("input").first().focus()
  @$("form.add-blueprint").formValidation(
    framework: 'bootstrap'
    live: "disabled"
    fields:
      name:
        validators:
          notEmpty:
            message: ''#'Please enter blueprint name'
      appendix:
        validators:
          notEmpty:
            message: ''# 'Please enter appendix'
      key:
        validators:
          notEmpty:
            message: ''# 'Please enter key'
          regexp:
            regexp: /^[\da-z\-]+$/
            message: "Only lowercase English letters and hyphen (example: \"delete-tags\")"
  ).on('success.form.fv', grab encapsulate (event) ->
    $form = $(event.currentTarget).closest("form") # ye olde IE
    blueprint = {}
    for field in $form.serializeArray()
      blueprint[field.name] = field.value
    Blueprints.insert(blueprint, Spire.handleError ->
      $form.data("formValidation").resetForm()
      $form[0].reset() # formValidation only resets the fields which have validators
      $form.find(":input:visible").first().focus()
    )
  )

Template.app.events
  "keyup .blueprint-icon": (event, template) ->
    Session.set("blueprintIcon", $(event.currentTarget).val())
