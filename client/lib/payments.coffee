$target = null
targetPlanId = null
targetPlan = null

Meteor.startup ->
  if Meteor.settings.public.stripe and (not Meteor.settings.public.isDebug or Meteor.settings.public.isPaymentDebug) # prevent "Mixed Content" warnings in console
    window.StripeHandler = StripeCheckout.configure(
      key: Meteor.settings.public.stripe.key
      name: "Spire"
      image: "/packages/frontend-foundation/public/images/logo-for-stripe.png"
      panelLabel: "Upgrade"
      token: -> Spire.tokenHandler.apply(@, arguments)
    )
  else
    window.StripeHandler =
      open: ->
        alert("Stripe payments are disabled in dev environment. To test payments, please set \"isPaymentDebug\": true in current settings file. Just don't forget to set it back!")
      close: ->

Spire.tokenHandler = (token) ->
  mixpanel.track("UpgradeTokenReceived", {userId: Meteor.userId()})
  $target.find(".ready").hide()
  $target.find(".loading").show()
  Meteor.call("addCard", token, (error) ->
    $target.find(".ready").show()
    $target.find(".loading").hide()
    if error then return Spire.showError(error)
    if targetPlanId
      Spire.updatePlan()
  )

Spire.updatePlanEventHandler = grab encapsulate (event) ->
  $target = $(event.currentTarget)
  targetPlanId = $target.attr("data-plan-id")
  targetPlan = _.findWhere(Spire.plans, {_id: targetPlanId})
  Spire.updatePlan()

Spire.updatePlan = ->
  user = Transformations.User(Meteor.user())
  mixpanel.track("UpgradeInitiated", {userId: user._id, fromPlanId: user.planId, toPlanId: targetPlanId})
  $target.find(".ready").hide()
  $target.find(".loading").show()
  Meteor.call("updatePlan", targetPlanId, (error) ->
    $target.find(".ready").show()
    $target.find(".loading").hide()
    if error
      if error.error in ["User:noStripeCustomer", "User:noStripeSources"]
        StripeHandler.open
          description: "#{targetPlan.name} plan"
          email: user.emails[0].address
      else
        Spire.showError(error)
      return
    mixpanel.track("UpgradeComplete", {userId: Meteor.userId()})
    parameters = Session.get("ongoingActionParameters")
    if parameters
      Spire.executeAction(parameters)
    $(".modal").modal("hide")
    $target = null
    targetPlanId = null
    targetPlan = null
  )
