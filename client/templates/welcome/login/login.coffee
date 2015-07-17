Template.login.helpers
  loginFormSignUp: ->
    Session.get("loginFormSignUp")

Template.login.onRendered ->

Template.login.events
  "click #at-google, click #at-btn": (event, template) ->
    $button = $(event.currentTarget)
#    $button.append("<div class='fa fa-fw fa-spin fa-spinner loading-spinner'></div>")
