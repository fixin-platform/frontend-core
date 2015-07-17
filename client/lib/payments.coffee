$target = null
targetPlanId = null
targetPlan = null

Meteor.startup ->
  if Meteor.settings.public.stripe and (not Meteor.settings.public.isDebug or Meteor.settings.public.isPaymentDebug) # prevent "Mixed Content" warnings in console
    window.StripeHandler = StripeCheckout.configure(
      key: Meteor.settings.public.stripe.key
      name: "Foreach"
      image: "/packages/foundation/public/images/logo-for-stripe.png"
      panelLabel: "Upgrade"
      token: -> Foreach.tokenHandler.apply(@, arguments)
    )
  else
    window.StripeHandler =
      open: ->
        alert("Stripe payments are disabled in dev environment. To test payments, please set \"isPaymentDebug\": true in current settings file. Just don't forget to set it back!")
      close: ->

Foreach.tokenHandler = (token) ->
  mixpanel.track("UpgradeTokenReceived", {userId: Meteor.userId()})
  $target.find(".ready").hide()
  $target.find(".loading").show()
  Meteor.call("addCard", token, (error) ->
    $target.find(".ready").show()
    $target.find(".loading").hide()
    if error then return Foreach.showError(error)
    if targetPlanId
      Foreach.updatePlan()
  )

Foreach.updatePlanEventHandler = grab encapsulate (event) ->
  $target = $(event.currentTarget)
  targetPlanId = $target.attr("data-plan-id")
  targetPlan = _.findWhere(Foreach.plans, {_id: targetPlanId})
  Foreach.updatePlan()

Foreach.updatePlan = ->
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
        Foreach.showError(error)
      return
    mixpanel.track("UpgradeComplete", {userId: Meteor.userId()})
    parameters = Session.get("ongoingActionParameters")
    if parameters
      Foreach.executeAction(parameters)
    $(".modal").modal("hide")
    $target = null
    targetPlanId = null
    targetPlan = null
  )
