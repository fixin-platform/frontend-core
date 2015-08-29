Template.blueprintTeaser.helpers
  app: ->
    Apps.findOne({key: Spire.getParam("appKey")})
  blueprint: ->
    app = Apps.findOne({key: Spire.getParam("appKey")})
    Blueprints.findOne({key: Spire.getParam("blueprintKey"), appId: app._id})
  tweetText: ->
    @blueprint.name + " " + @blueprint.appendix + " in " + @app.name + ", anybody?"
  currentUserVote: ->
    Votes.findOne({app: @appKey, action: @blueprintKey, userToken: currentUserToken})
  currentUserTokenEmail: ->
    TokenEmails.findOne({userToken: currentUserToken})
  votesCount: ->
    1 + Counts.get("VotesCountByAppAndBlueprint")
  votesCountDown: ->
    10 - (1 + Counts.get("VotesCountByAppAndBlueprint"))

Template.blueprintTeaser.onRendered ->
  # TODO: move this to waitOn and implement loading template
  @$("form").formValidation(
    framework: 'bootstrap'
    live: "disabled"
    fields:
      email:
        validators:
          notEmpty:
            message: 'Please enter your email address'
          emailAddress:
            message: 'Please enter a valid email address'
  ).on('success.form.fv', grab encapsulate (event) ->
      $form = $(event.currentTarget).closest("form") # ye olde IE
      parameters = {}
      for field in $form.serializeArray()
        parameters[field.name] = field.value
      TokenEmails.insert(
        email: parameters.email
      )
  )
  @autorun =>
    Meteor.subscribe("VotesCountByAppAndBlueprint", @data.appKey, @data.blueprintKey)

Template.blueprintTeaser.events
  "click .vote": encapsulate (event, template) ->
    if not Votes.findOne({app: @appKey, action: @blueprintKey, userToken: currentUserToken})
      Votes.insert({app: @appKey, action: @blueprintKey, userToken: currentUserToken})

