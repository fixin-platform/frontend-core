Template.greed.helpers
  _name: ->
    i18n.t("actions.Trello.#{@action}.name")
  _shorthand: ->
    i18n.t("actions.Trello.#{@action}.shorthand")
  _appendixAllSelected: ->
    i18n.t("actions.Trello.#{@action}.appendix", {selectionLength: 42}).replace("42", "all selected")
  actions: ->
    Spire.currentUser({"actions": 1}).actions
  amount: ->
    neededActions = Counts.get("selectedCards") - Math.max(0, Spire.currentUser({"actions": 1}).actions)
    Spire.price * neededActions
  round: (value) ->
    Math.round(value) or 1
  aLotOfTime: ->
    time = 3 * Counts.get("selectedCards")
    unit = "second"
    if time > 60
      time /= 60
      unit = "minute"
      if time > 60
        time /= 60
        unit = "hour"
    time = Math.round(time)
    i18n.t("billing.time." + unit, {count: time})
  higherPlan: ->
    currentUserPlan = UI._globalHelpers.currentUserPlan.call(@)
    for plan in Spire.plans
      if not plan.limit or plan.limit > currentUserPlan.limit
        break
    return plan

Template.greed.onRendered ->
  mixpanel.track("UpgradePopupShown", {userId: Meteor.userId()})
  $modal = $(@firstNode).closest(".modal")
  if $modal.length
    $modal.on("hide.bs.modal", ->
      Session.set("ongoingActionParameters", null)
    )
    Session.set("ongoingActionParameters", @data)

Template.greed.events
  "click a": grab encapsulate (event, template) ->
    $target = $(event.currentTarget)
    $alternativePeriod = $target.closest(".alternative-period")
    if $alternativePeriod.length
      Session.set("period", $alternativePeriod.attr("data-period"))
      return
    Router.go($target.href)
