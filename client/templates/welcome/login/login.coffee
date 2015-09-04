Template.login.helpers
  loginFormSignUp: ->
    Session.get("loginFormSignUp")

Template.login.onRendered ->

Template.login.events
#  "click a": grab encapsulate (event, template) ->
#    debugger
#    # just for grab encapsulate
#    # otherwise useraccounts redirects to sign-in route
  "click #at-google, click #at-btn": (event, template) ->
    $button = $(event.currentTarget)
#    $button.append("<div class='fa fa-fw fa-spin fa-spinner loading-spinner'></div>")
