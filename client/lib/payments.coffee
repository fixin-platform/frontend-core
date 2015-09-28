stripe = new StripeKonnect("Spire")

window.stripe = stripe if Meteor.settings.public.isDebug

# -- currently, the afterPayment system is disabled (naive implementation is too flaky, robust implementation needs more work than is justified at the moment) --
# The candidate system ensures that afterPayment is called only when the plan is updated in response to 402 error from server
# Consider the following user flow:
# * User runs a Command
# * User is presented with a greed modal
# * User closes the greed modal
# * User goes to /pricing
# * User upgrades from there
# * The Command shouldn't be inserted again, but it will be inserted, because afterPayment is not cleared after the user goes to /pricing
# The best way

Spire.afterPaymentAutorun = (func) ->
  Spire.afterPaymentCandidate = func
  func() # current user plan is checked on server

Spire.afterPaymentPromoteCandidate = ->
  Spire.afterPayment = Spire.afterPaymentCandidate
  Spire.afterPaymentCandidate = ->

Spire.afterPaymentReset = ->
  Spire.afterPayment = ->
  Spire.afterPaymentCandidate = ->

Spire.afterPaymentReset()

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
  user = Spire.currentUser()
  mixpanel.track("UpgradeInitiated", {userId: user._id, fromPlanId: user.planId, toPlanId: targetPlanId})
  $target.find(".ready").hide()
  $target.find(".loading").show()
  if not user.stripeCustomerId
    Spire.openStripeCheckoutHandler(user, $target, targetPlan)
  else
    Meteor.call("updatePlan", targetPlanId, Spire.createErrback(
      (error) ->
        mixpanel.track("UpgradeComplete", {userId: Meteor.userId()})
        # --disabled-- Spire.afterPayment() # Spire.afterPaymentReset() should be called in the afterPayment function itself (e.g. as callback for Collection.insert)
        $(".modal").modal("hide")
    ,
      ->
        $target.find(".ready").show()
        $target.find(".loading").hide()
    ))

Spire.openStripeCheckoutHandler = (user, $target, targetPlan) ->
  stripe.ready ->
    handler = stripe.getCheckoutHandler(
      panelLabel: "Upgrade"
      description: "#{targetPlan.name} plan"
      email: user.emails[0].address
      token: _.partial(Spire.addCard, $target, targetPlan._id)
      opened: ->
        $target.find(".ready").show()
        $target.find(".loading").hide()
    )
    handler.open()
