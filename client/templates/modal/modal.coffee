Template.modal.helpers
#  helper: ->

Template.modal.onRendered ->
  modal = @firstNode
  $(".modal").each (index, existingModal) ->
    if existingModal isnt modal
      $(existingModal).modal("hide")
  view = @view
  $modal = $(modal)
  $modal.modal()
  $modal.on("hidden.bs.modal", ->
    Blaze.remove(view)
  )

Template.modal.events
# layout doesn't have access to modals in body
  "click .add-payment-method": Spire.updatePlanEventHandler
