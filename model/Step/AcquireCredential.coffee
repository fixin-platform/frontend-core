# TODO: use ChooseAvatar Step

class Steps.AcquireCredential extends Steps.Step
  template: "AcquireCredential"
  constructor: (config) ->
    check config, Match.ObjectIncluding
      scopes: [String]
    super
  isCompleted: ->
    !!@credential()
  revert: ->
    credential = @credential()
    Credentials.remove(credential._id) if credential
  change: -> @revert()
  credential: ->
    Credentials.findOne({api: @api, scopes: {$all: @scopes}, userId: @recipe().userId})
  _i18nKey: ->
    "steps.AcquireCredential"
  _i18nParameters: ->
    api: @api
