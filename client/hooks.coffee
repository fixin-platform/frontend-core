Users.after.update (userId, user, fieldNames, modifier, options) ->
  if modifier.$set?["options.Trello.withArchivedObjects"]? # check if key exists
    Spire.sendMessageWithoutDuplicates({type: "load", recipe: "TrelloForeach"}, {type: "load", recipe: "TrelloForeach", withArchivedObjects: !!user.options?.Trello?.withArchivedObjects})
  true
