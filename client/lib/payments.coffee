stripe = new StripeKonnect("Spire")

window.stripe = stripe if Meteor.settings.public.isDebug

Spire.addCard = ($target, targetPlanId, token) ->
  mixpanel.track("UpgradeTokenReceived", {userId: Meteor.userId()})
  $target.find(".ready").hide()
  $target.find(".loading").show()
  Meteor.call("addCard", token, (error) ->
    $target.find(".ready").show()
    $target.find(".loading").hide()
    return Spire.showError(error) if error
    return Spire.updatePlan($target, targetPlanId)
  )

Spire.updatePlanEventHandler = grab encapsulate (event) ->
  $target = $(event.currentTarget)
  targetPlanId = $target.attr("data-plan-id")
  Spire.updatePlan($target, targetPlanId)

Spire.updatePlan = ($target, targetPlanId) ->
  targetPlan = _.findWhere(Spire.plans, {_id: targetPlanId})
  throw new Error("Couldn't find plan \"#{targetPlanId}\"") unless targetPlan
  user = Transformations.User(Meteor.user())
  mixpanel.track("UpgradeInitiated", {userId: user._id, fromPlanId: user.planId, toPlanId: targetPlanId})
  $target.find(".ready").hide()
  $target.find(".loading").show()
  Meteor.call("updatePlan", targetPlanId, (error) ->
    if error
      if error.error in ["User:noStripeCustomer", "User:noStripeSources"]
        stripe.ready ->
          handler = stripe.getCheckoutHandler(
            panelLabel: "Upgrade"
            description: "#{targetPlan.name} plan"
            email: user.emails[0].address
            token: _.partial(Spire.addCard, $target, targetPlanId)
            opened: ->
              $target.find(".ready").show()
              $target.find(".loading").hide()
          )
          handler.open()
      else
        $target.find(".ready").show()
        $target.find(".loading").hide()
        Spire.showError(error)
      return
    $target.find(".ready").show()
    $target.find(".loading").hide()
    mixpanel.track("UpgradeComplete", {userId: Meteor.userId()})
    parameters = Session.get("ongoingActionParameters")
    Spire.executeAction(parameters) if parameters
    $(".modal").modal("hide")
  )
