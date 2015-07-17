class Steps.RunTask extends Steps.Step
  template: "RunTask"
#  constructor: (config) ->
#    check config, Match.ObjectIncluding
#      api: String
#      scopes: [String]
#    super
#  options: ->
#    return [] unless Session.get("step-#{@_id}-avatars-subscription-is-initialized")
#    subs[@_id].avatars.reactive()
#  execute: (values) ->
#    $set = _.extend(
#      isCompleted: true
#    , values)
#    Steps.update(@_id, {$set: $set})
#  revert: ->
#    $set =
#      isCompleted: false
#    $unset =
#      avatarId: 1
#    Steps.update(@_id, {$set: $set, $unset: $unset})
#  _i18nParameters: ->
#    api: @api
