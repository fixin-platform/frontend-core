Template.health.helpers
  Users: ->
    Counts.get("Users")
  UsersNotAliasedByMixpanel: ->
    Counts.get("UsersNotAliasedByMixpanel")

Template.health.onRendered ->
  @$(".refresh-outstanding-polls").trigger("click")
  @autorun ->
    Meteor.subscribe("Users")
    Meteor.subscribe("UsersNotAliasedByMixpanel")

Template.health.events
  "click .sync-users-with-mixpanel": grab encapsulate (event, template) ->
    $button = $(event.currentTarget)
    $button.find(".ready").hide()
    $button.find(".loading").show()
    Meteor.call("syncWithMixpanel", Spire.handleError (error, emails) ->
      $button.find(".ready").show()
      $button.find(".loading").hide()
      alert("Added #{emails.join(", ")}")
    )
  "click .refresh-outstanding-polls": grab encapsulate (event, template) ->
    Meteor.call("getOutstandingPolls", Spire.handleError (error, outstandingPolls) ->
        $(".outstanding-polls").text(outstandingPolls)
    )

