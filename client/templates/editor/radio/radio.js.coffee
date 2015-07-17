Template.radio.helpers
  isChecked: ->
    @object[@property] is @value

Template.radio.onRendered ->

Template.radio.events
  "change .property-editor": encapsulate (event, template) ->
    $set = {}
    $set[template.data.property] = $(event.currentTarget).val()
    editor = EditorCache.editors[template.data.family]
    editor.collection.update(template.data._id, {$set: $set})
