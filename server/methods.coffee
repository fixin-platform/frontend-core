stripe = Npm.require("stripe")(Meteor.settings.stripe.secret) if Meteor.settings.stripe

Spire.saveCredential = (avatarValues, credentialValues) ->
  avatarSelector = # same as postgresqlSelector for now, but that's just a coincidence; see the possible difference below in Credential-related code
    api: avatarValues.api
    uid: avatarValues.uid
    userId: avatarValues.userId

  now = new Date()
  $set = avatarValues
  $set.updatedAt = now
  $setOnInsert = {createdAt: $set.updatedAt}
  upsertRes = Avatars.upsert(avatarSelector, {$setOnInsert: $setOnInsert, $set: $set})
  avatarId = upsertRes.insertedId or Avatars.findOne(avatarSelector)._id

  credentialSelector =
    scopes: {$all: credentialValues.scopes}
    avatarId: avatarId
  $set = credentialValues
  $set.updatedAt = now
  $setOnInsert = {createdAt: $set.updatedAt}
  Credentials.upsert(credentialSelector, {$setOnInsert: $setOnInsert, $set: $set})

  avatarId

Meteor.methods
  alias: secure (distinct_id) ->
    check(distinct_id, String)
    user = Users.findOne(@userId)
    if user.isAliasedByMixpanel
      throw new Meteor.Error("user-already-aliased-by-mixpanel", "Current user is already aliased by Mixpanel", _.deepExtend({}, user))
    mixpanelAlias = Meteor.wrapAsync(mixpanel.alias, mixpanel)
    mixpanelAlias(distinct_id, @userId)
    mixpanel.track("$signup", {userId: @userId})
    Users.update(@userId, {$set: {isAliasedByMixpanel: true}})
  saveOAuthCredential: secure (credentialToken, credentialSecret, api, scopes) ->
    info = OAuth.retrieveCredential(credentialToken, credentialSecret)
    now = new Date()
    serviceData = info.serviceData
    avatarValues =
      api: api
      uid: serviceData.id
      name: info.options.profile.name
      userId: @userId
    credentialValues =
      api: api
      scopes: serviceData.scopes or scopes # Facebook allows the user to modify the scopes
      details: _.extend serviceData,
        accessToken: serviceData.accessToken
        refreshToken: serviceData.refreshToken
        expiresAt: new Date(serviceData.expiresAt)
      updatedAt: now
      userId: @userId
    switch api
      when "Twitter"
        avatarValues.imageUrl = serviceData.profile_image_url_https
        avatarValues.name = "@" + serviceData.screenName
      when "Google"
        avatarValues.imageUrl = serviceData.picture
    Spire.saveCredential(avatarValues, credentialValues)
  getOutstandingPolls: secure admin ->
    Queue.worker.outstandingPolls
  syncWithMixpanel: secure admin (userId) ->
    check(userId, Match.Optional(Match.StringId))
    emails = []
    selector =
      flags: {$nin: ["IsDuplicate"]}
    if userId
      selector._id = userId
    Users.find(selector).forEach (user) ->
      data = mixpanel.call("GET", "http://mixpanel.com/api/2.0/engage/",
        where: "properties[\"_id\"] == \"#{user._id}\""
      )
      mixpanelUser = data.results[0]
      if not mixpanelUser
        l("User:sync-with-mixpanel", user)
        mixpanel.track("$signup", {userId: user._id, time: user.createdAt.getTime()})
        mixpanel.track_user(user)
        Users.update(user._id, {$set: {isAliasedByMixpanel: true}})
        emails.push(user.emails[0].address)
    emails
  updatePlan: secure (planId) ->
    check(planId, Match.InArray(_.pluck(Spire.plans, "_id")))
    user = Users.findOne(@userId)
    if user.planId is planId
      # this is likely bug in our code, so let's throw the error to learn about it in Kadira
      throw new Meteor.Error("User:samePlanId", "This user is already on the same plan, no need to upgrade", {planId: planId, user: _.deepClone(user)})
    stripeCustomer = null
    if user.stripeCustomerId
      stripeCustomer = Meteor.wrapAsync(stripe.customers.retrieve, stripe.customers)(user.stripeCustomerId)
    if not stripeCustomer # may not be present in Stripe
      throw new Meteor.Error("User:noStripeCustomer", "This user has no Stripe customer associated with him", {user: _.deepClone(user)})
    if not stripeCustomer.sources.data.length
      throw new Meteor.Error("User:noStripeSources", "This Stripe customer has no payment sources associated with him", {stripeCustomer: stripeCustomer})
    if stripeCustomer.subscriptions.data.length
      Meteor.wrapAsync(stripe.customers.updateSubscription, stripe.customers)(stripeCustomer.id, stripeCustomer.subscriptions.data[0].id,
        plan: planId
      )
    else
      Meteor.wrapAsync(stripe.customers.createSubscription, stripe.customers)(stripeCustomer.id,
        plan: planId
      )
    # if Stripe call errors out, it will throw an exception
    stripeCustomer = Meteor.wrapAsync(stripe.customers.retrieve, stripe.customers)(stripeCustomer.id)
    Users.update(@userId, {$set: {"planId": planId}})
  addCard: secure (token) ->
    user = Users.findOne(@userId)
    stripeCustomer = null
    if user.stripeCustomerId
      stripeCustomer = Meteor.wrapAsync(stripe.customers.retrieve, stripe.customers)(user.stripeCustomerId)
    else
      stripeCustomer = Meteor.wrapAsync(stripe.customers.create, stripe.customers)(
        email: user.emails[0].address
      )
    if not stripeCustomer
      throw new Meteor.Error("User:noStripeCustomer", "This user has no Stripe customer associated with him", {user: _.deepClone(user)})
    Users.update(@userId, {$set: {stripeCustomerId: stripeCustomer.id}})
    Meteor.wrapAsync(stripe.customers.createCard, stripe.customers)(stripeCustomer.id,
      card: token.id
    )
  sendMeMail: secure (subject, text) ->
    check(subject, String)
    check(text, String)
    user = Users.findOne(@userId)
    Email.send(
      to: "denis.d.gorbachev@gmail.com",
      from: "\"#{user.profile.name}\" <#{user.emails[0].address}>",
      subject: subject,
      text: text
    )
  readErrors: secure (messageId) ->
    check(messageId, Match.StringId)
    message = Messages.findOne(messageId)
    if (message && message.jobsCount <= 0)
      Messages.remove(messageId)
