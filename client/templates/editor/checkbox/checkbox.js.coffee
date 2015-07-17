Template.checkbox.helpers

Template.checkbox.onRendered ->

Template.checkbox.events
  "change .property-editor": encapsulate (event, template) ->
    $set = {}
    $set[template.data.property] = event.currentTarget.checked
    editor = EditorCache.editors[template.data.family]
    editor.collection.update(template.data._id, {$set: $set})
