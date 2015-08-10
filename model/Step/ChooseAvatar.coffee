class Steps.ChooseAvatar extends Steps.Step
  # TODO: implement class-specific checks in hooks (security isn't called on server)
  template: "ChooseAvatar"
  constructor: (config) ->
    check config, Match.ObjectIncluding
      api: String
      scopes: [String]
    super
  execute: (values) ->
    values.avatarId = Foreach.strval(values.avatarId)
    $set = _.extend(
      isCompleted: true
    , values)
    Steps.update(@_id, {$set: $set})
  revert: ->
    $set =
      isCompleted: false
    $unset =
      avatarId: 1
    Steps.update(@_id, {$set: $set, $unset: $unset})
  _i18nParameters: ->
    api: @api
    avatar: @avatar()
  avatar: ->
    Avatars.findOne(@avatarId)
