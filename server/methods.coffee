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
      details: serviceData
      updatedAt: now
      userId: @userId
    if serviceData.expiresAt
      serviceData.expiresAt = new Date(serviceData.expiresAt)
    switch api
      when "Twitter"
        avatarValues.imageUrl ?= serviceData.profile_image_url_https
        avatarValues.name ?= "@" + serviceData.screenName
      when "Google"
        avatarValues.imageUrl ?= serviceData.picture
        avatarValues.name ?= serviceData.name
        avatarValues.name = "#{avatarValues.name} (#{serviceData.email})"
      when "Bitly"
        avatarValues.imageUrl ?= serviceData.profile_image
        avatarValues.name ?= serviceData.display_name or serviceData.login
    serviceConfiguration = ServiceConfiguration.configurations.findOne({service: api.toLowerCase()})
    throw new Error("Service configuration not found for #{api}") unless serviceConfiguration
    _.extend credentialValues.details, _.omit(serviceConfiguration, "_id", "service") # required for backend
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
