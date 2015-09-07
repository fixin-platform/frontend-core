#return if not Meteor.settings.stripe

settings = Meteor.settings.ripest
settings.apiKey = "sk_#{settings.keyType}_#{settings.apiKey_part1}#{settings.apiKey_part2}"
settings.publishableKey = "pk_#{settings.keyType}_#{settings.publishableKey_part1}#{settings.publishableKey_part2}"
stripe = new StripeKonnect("Spire")
stripe.configure settings

Meteor.methods
  updatePlan: secure (planId) ->
    check(planId, Match.InArray(_.pluck(Spire.plans, "_id")))
    user = Users.findOne(@userId)
    if user.planId is planId
  # this is likely bug in our code, so let's throw the error to learn about it in Kadira
      throw new Meteor.Error("User:samePlanId", "This user is already on the same plan, no need to upgrade", {planId: planId, user: _.deepClone(user)})
    stripeCustomer = null
    if user.stripeCustomerId
      stripeCustomer = stripe.customers.retrieve(user.stripeCustomerId)
    if not stripeCustomer # may not be present in Stripe
      throw new Meteor.Error("User:noStripeCustomer", "This user has no Stripe customer associated with him", {user: _.deepClone(user)})
    if not stripeCustomer.sources.data.length
      throw new Meteor.Error("User:noStripeSources", "This Stripe customer has no payment sources associated with him", {stripeCustomer: stripeCustomer})
    if stripeCustomer.subscriptions.data.length
      stripe.customers.updateSubscription(stripeCustomer.id, stripeCustomer.subscriptions.data[0].id,
        plan: planId
      )
    else
      stripe.customers.createSubscription(stripeCustomer.id,
        plan: planId
      )
  # if Stripe call errors out, it will throw an exception
    stripeCustomer = stripe.customers.retrieve(stripeCustomer.id)
    Users.update(@userId, {$set: {"planId": planId}})

  addCard: secure (token) ->
    user = Users.findOne(@userId)
    stripeCustomer = null
    if user.stripeCustomerId
      stripeCustomer = stripe.customers.retrieve(user.stripeCustomerId)
    else
      stripeCustomer = stripe.customers.create(
        email: user.emails[0].address
      )
    if not stripeCustomer
      throw new Meteor.Error("User:noStripeCustomer", "This user has no Stripe customer associated with him", {user: _.deepClone(user)})
    Users.update(@userId, {$set: {stripeCustomerId: stripeCustomer.id}})
    stripe.customers.createCard(stripeCustomer.id,
      card: token.id
    )
