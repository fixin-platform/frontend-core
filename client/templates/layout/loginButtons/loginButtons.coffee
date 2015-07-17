Template.loginButtons.helpers
#  helper: ->

Template.loginButtons.onRendered ->
  if Accounts._resetPasswordToken
    AccountsTemplates.paramToken = Accounts._resetPasswordToken
    AccountsTemplates.setState("resetPwd")
    $("#loginPopup").modal("show")

Template.loginButtons.events
  "click .login-button": (event, template) ->
    AccountsTemplates.setState("signUp");
    $('#loginPopup').modal('show')
  "click .sign-in-form": (event, template) ->
    AccountsTemplates.setState("signIn");
    $('#loginPopup').modal('show')

