class Steps.ChooseOAuthAvatar extends Steps.ChooseAvatar
  type: "connect"
  callback: (error, avatarId) ->
    @execute({avatarId: avatarId})
