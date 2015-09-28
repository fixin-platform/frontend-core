Template.header.helpers
  shouldDisplay: ->
    user = Spire.currentUser({"isInternal": 1, "isAdmin": 1, "flags": 1})
    return false if not user
    return false if user.isAdmin
    return false if user.isInternal
    return false if user.isKimKardashian # forward compatibility
    return false if "InterestedInCustomVersion" in user.flags
    return false if Pack.isApplied
    return true # at last
  isRealName: ->
    Spire.currentUser({"profile": 1}).profile.isRealName
  firstName: ->
    Spire.currentUser({"profile": 1}).firstName()

Template.header.onRendered ->

Template.header.events
  "click button": encapsulate (event, template) ->
    Meteor.call("sendMeMail", "Custom API integration", "")
    Blaze.renderWithData(Template.modal,
      template: "customVersion"
    , document.body)
