Template.menu.helpers
  canSeeSteps: ->
    user = Foreach.currentUser({isAdmin: 1})
    user and (user.isAdmin or Pack.isApplied)

Template.menu.onRendered ->

Template.menu.events
  "click .disconnect": grab (event, template) ->
    # TODO: this will be removed anyway when we migrate Trello stuff to Steps
    api = $(event.currentTarget).attr("data-api")
    credential = Credentials.findOne({api: api, userId: Meteor.userId()})
    throw "User tried to remove non-existent credential" if not credential
    Credentials.remove(credential._id)
