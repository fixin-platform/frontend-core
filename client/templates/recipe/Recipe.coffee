Template.Recipe.helpers
  steps: ->
    @steps({}, {sort: {position: 1}})

Template.Recipe.events
  "click .step .execute": (event, template) ->
    event.preventDefault()
    event.stopPropagation() # but not event.stopImmediatePropagation() --- allow for multi-handlers
    @execute()
  "click .step .revert": (event, template) ->
    event.preventDefault()
    event.stopPropagation() # but not event.stopImmediatePropagation() --- allow for multi-handlers
    @revert()
    @changeAllNext()
    @revertAllNext()
  "click .step .change": (event, template) ->
    event.preventDefault()
    event.stopPropagation() # but not event.stopImmediatePropagation() --- allow for multi-handlers
    @change()
    # UI: Only revert if something has really changed; the user may save the form with the same values
    @changeAllNext()
    @revertAllNext()
  "submit .step form:not(.self-validation)": grab encapsulate (event, template) ->
    $form = $(event.currentTarget).closest("form") # ye olde IE
    values = {}
    for field in $form.serializeArray()
      if values[field.name]
        if not _.isArray(values[field.name])
          oldValue = values[field.name]
          values[field.name] = [oldValue]
        values[field.name].push(field.value)
      else
        values[field.name] = field.value
    @execute(values)
