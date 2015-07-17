Template.recipeBadge.helpers
#  helper: ->

Template.recipeBadge.onRendered ->

Template.recipeBadge.events
  "click .edit-name": grab encapsulate (event, template) ->
    $link = $(event.currentTarget)
    if (name = prompt($link.attr("data-prompt"), @name))
      Recipes.update(@_id, {$set: {name: name}})
    $link.closest(".dropdown").find(".dropdown-toggle").dropdown('toggle')
  "click .remove": grab encapsulate (event, template) ->
    $link = $(event.currentTarget)
    if (confirm($link.attr("data-confirm")))
      Recipes.remove(@_id)
    $link.closest(".dropdown").find(".dropdown-toggle").dropdown('toggle')
