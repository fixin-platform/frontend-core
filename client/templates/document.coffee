$document = $(document)

$document.on "click", ".logout", grab encapsulate (event) ->
  Meteor.logout ->
    # redirect might be necessary to prevent Mixpanel distinct_id overwrite
    # not sure if mixpanel.cookie.clear() fixes this
    mixpanel.cookie.clear()
    location.href = location.protocol + "//" + location.hostname + (if location.port then ':' + location.port else '') + "/"

$document.on "click", ".login", grab encapsulate (event) ->
  Spire.requireLogin()

$document.on "click", ".reconnect", grab encapsulate (event) ->
  Meteor.reconnect()

$document.on "click", ".update-plan", Spire.updatePlanEventHandler

$document.on "click", ".connect-to-api", grab encapsulate (event) ->
  $target = $(event.currentTarget)
  $target.find(".ready").hide()
  $target.find(".loading").show()
  api = $target.attr("data-api")
  scopes = $target.attr("data-scopes").split(",")
  mixpanel.track("OAuthFlowInitiated", {userId: Meteor.userId(), api: api})
  connect(api, scopes, (credentialTokenOrError) ->
    $target.find(".ready").show()
    $target.find(".loading").hide()
  )

connect = (api, scopes, callback) ->
  check(api, String)
  check(scopes, [String])
  check(callback, Match.Optional(Function))
  if api is "Trello"
    sourceUrl = location.protocol + "//" + location.hostname + (if location.port then ':' + location.port else '') + Iron.Location.get().path
    Meteor.call("getToken", sourceUrl, Spire.handleError (error, token) ->
      callback?(error, token)
      location.href = "https://trello.com/1/OAuthAuthorizeToken?name=Spire:+bulk+actions+for+Trello&scope=#{scopes.join(",")}&oauth_token=" + token
    )
  else
    switch api
      when "Google"
        scopes.push "email" # need this scope to get email for display in "Choose account" dropdown
    @[api].requestCredential(
      requestPermissions: scopes
      requestOfflineToken: true
      forceApprovalPrompt: true # also get refreshToken for offline access. The regular online accessToken is too short-lived
    , (credentialTokenOrError) ->
      # may also error if the user explicitly cancels authentication or closes the popup window
      return callback?(credentialTokenOrError) if credentialTokenOrError instanceof Error
      credentialToken = credentialTokenOrError # would have returned otherwise
      credentialSecret = OAuth._retrieveCredentialSecret(credentialToken)
      if credentialSecret
        return Meteor.call("saveOAuthCredential", credentialToken, credentialSecret, api, scopes, callback)
      # TODO: credentialSecret may be absent, because the user declined authorization - or there was some error?
    )

