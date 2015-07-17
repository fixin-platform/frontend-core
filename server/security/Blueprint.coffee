Blueprints.allow
  insert: introspect (userId, blueprint) ->
    throw new Meteor.Error("User:unauthenticated", "User not authenticated") if not userId
    throw new Meteor.Error("User:insufficient-permissions", "Editor or Admin only") if not (isAdmin(userId) or isEditor(userId))
    Logger.log("Blueprint:create", blueprint)
    check(blueprint,
      _id: Match.StringId
      appId: Match.ObjectId(Apps)
      key: String
      name: String
      appendix: String
      icon: String
      position: Match.Integer
      userId: Match.ObjectId(Users)
      updatedAt: Date
      createdAt: Date
    )
    blueprint.key = blueprint.key.toLowerCase().replace(/[^\da-z\-]/g, "")
    duplicate = Blueprints.findOne(_.pick(blueprint, ["app", "key"]))
    if duplicate
      throw new Meteor.Error("Blueprint:duplicate", "Blueprint can't be created because the blueprint \"#{duplicate.key}\" already exists", _.clone(duplicate))
    Logger.log("Blueprint:created", blueprint)
    true
  update: introspect editor (userId, blueprint, fieldNames, modifier, options) ->
#    throw new Meteor.Error("User:unauthenticated", "User not authenticated") if not userId
#    throw new Meteor.Error("User:insufficient-permissions", "Editor or Admin only") if not (isAdmin(@userId) or isEditor(@userId))
    false
  remove: introspect editor (userId, blueprint) ->
#    throw new Meteor.Error("User:unauthenticated", "User not authenticated") if not userId
#    throw new Meteor.Error("User:insufficient-permissions", "Editor or Admin only") if not (isAdmin(@userId) or isEditor(@userId))
    false
