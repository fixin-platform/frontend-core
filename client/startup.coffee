Package.type = "browser" if not Package.type

# TODO save action and parameters in database
Session.setDefault("action", "")
Session.setDefault("period", "month")
Session.set("ongoingActionParameters", null)

Meteor.startup ->
  userId = Meteor.userId()
  if Meteor.settings.public.isDevLogin
    if (!userId && (location.host == "localhost:3000" || location.host.indexOf("192.168") != -1) && document.cookie.indexOf("autologin=false") == -1)
      if jQuery.browser.mozilla
        Meteor.loginWithToken("ArunodaSusiripala")
      else
        Meteor.loginWithToken("DenisGorbachev")

currentUserToken = if Meteor.settings.public.isDebug then "token_J7H9PNSNPQL5jymRx" else store.get("userToken")
if not currentUserToken
  currentUserToken = "token_" + Random.id()
  store.set("userToken", currentUserToken)


if Meteor.settings.public.facebook
  window.fbAsyncInit = ->
    FB.init(
      appId: Meteor.settings.public.facebook.appId
      xfbml: true
      version: "v2.2"
    )

# Close Checkout on page navigation
$(window).on "popstate", ->
  window.StripeHandler?.close()

Spire.autologinDetected = false
Spire.isAutologin = ->
  Spire.autologinDetected or location.href.indexOf("/autologin") isnt -1

AccountsTemplates.configure
  enablePasswordChange: true
  showForgotPasswordLink: true
  showLabels: false
  negativeValidation: true
  positiveFeedback: true
  showValidating: true
  overrideLoginErrors: false
  defaultLayout: "layout",
  defaultLayoutRegions: {}
  defaultContentRegion: "content"
  texts:
    signInLink_pre: "Already have an account?"
    signUpLink_link: "Sign up"
    signInLink_link: "Sign in"
    socialSignUp: "Sign up"
    button:
      signUp: "Sign up"
    errors:
      loginForbidden: "Please enter email and password"
  onSubmitHook: (error, state) ->
    return if error
    $(Spire.document.body).find("#loginPopup").modal("hide") if state in ["signIn", "signUp"]



