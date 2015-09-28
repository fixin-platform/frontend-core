Meteor.publish "currentUser", ->
  # There is also a built-in Meteor publication which exposes "username", "emails", "profile" fields
  Users.find({_id: @userId},
    fields:
      "isAdmin": 1
      "isEditor": 1
      "isAliasedByMixpanel": 1
      "isInternal": 1
      "group": 1
      "createdAt": 1
      "isNew": 1
      "planId": 1
      "executions": 1
      "flags": 1
      "selections": 1
      "options": 1,
      "stripeCustomerId": 1 # hide it later
  )

# Stats

Meteor.publish "allUsers", ->
  return [] if not isAdmin(@userId)
  Users.find()

# Health

Meteor.publish "Users", ->
  return [] if not isAdmin(@userId)
  Counts.publish(@, "Users", Users.find())
  []

Meteor.publish "UsersNotAliasedByMixpanel", ->
  return [] if not isAdmin(@userId)
  Counts.publish(@, "UsersNotAliasedByMixpanel", Users.find({isAliasedByMixpanel: {$exists: false}}))
  []

Meteor.publish "Blueprints", ->
  Blueprints.find({})

Meteor.publish "RecipesCount", ->
  return [] unless @userId
  Counts.publish(@, "Recipes", Recipes.find({userId: @userId}))
  []

Meteor.publishComposite "Recipes",
  find: ->
    return [] unless @userId
    Recipes.find({userId: @userId})
  children: [
    find: (recipe) ->
      Pages.find({cls: "Landing", "options.recipe.cls": recipe.cls})
  ]

Meteor.publish "RecipesOnAutorun", ->
  return [] unless @userId
  Recipes.find({userId: @userId, isAutorun: true})

Meteor.publish "RecipesByCls", (cls) ->
  check(cls, String)
  return [] unless @userId
  Recipes.find({userId: @userId, cls: cls})

Meteor.publish "RecipesByPageUrl", (url) ->
  check(url, String)
  return [] unless @userId
  page = Pages.findOne({url: url}, {fields: {options: 1}})
  return [] unless page
  Recipes.find({userId: @userId, cls: page.options.recipe.cls})

Meteor.publish "Recipe", (_id) ->
  check(_id, Match.StringId)
  return [] unless @userId
  Recipes.find({_id: _id, userId: @userId})

Meteor.publish "Steps", ->
  return [] unless @userId
  Steps.find({userId: @userId})

Meteor.publish "Step", (_id) ->
  check(_id, Match.StringId)
  return [] unless @userId
  Steps.find({_id: _id, userId: @userId})

Meteor.publish "StepsByRecipeId", (recipeId) ->
  check(recipeId, Match.StringId)
  return [] unless @userId
  Steps.find({recipeId: recipeId, userId: @userId})

Meteor.publish "CommandsByStepId", (stepId) ->
  check(stepId, Match.StringId)
  return [] unless @userId
  Commands.find({stepId: stepId, userId: @userId}, {fields: {runId: 0}})

Meteor.publish "IssuesByStepId", (stepId) ->
  check(stepId, Match.StringId)
  return [] unless @userId
  Issues.find({stepId: stepId, userId: @userId})

Meteor.publish "RowsByStepId", (stepId, page, limit, search) ->
  check(stepId, Match.StringId)
  check(page, Match.Integer)
  check(limit, Match.Integer)
  check(search, String)
  return [] unless @userId
  page = Math.max(Spire.intval(page), 1)
  limit = Math.max(Spire.intval(limit), Spire.pageLimit)
  selector = {isReady: true, stepId: stepId, userId: @userId}
  if search
    search = if search.charAt(0) is "!" then "^(?!.*" + RegExp.escape(search.substr(1)) + ")" else RegExp.escape(search)
    selector.search = new RegExp(search, "i")
  # can't use text index, because it matches full word stems (so it won't match "blueberry" if user enters "blue")
  Rows.find(selector, {skip: (page - 1) * limit, limit: limit, sort: {createdAt: -1}, fields: {search: 0}})

Meteor.publish "RowsCountByStepId", (stepId, search) ->
  check(stepId, Match.StringId)
  check(search, String)
  return [] unless @userId
  selector = {isReady: true, stepId: stepId, userId: @userId}
  selector.search = new RegExp(RegExp.escape(search), "i") if search
  Counts.publish(@, "RowsCountByStepId", Rows.find(selector))
  []

Meteor.publish "Columns", (stepId) ->
  check(stepId, Match.StringId)
  return [] unless @userId
  Columns.find({stepId: stepId, userId: @userId})

Meteor.publish "Filters", (stepId) ->
  check(stepId, Match.StringId)
  return [] unless @userId
  Filters.find({stepId: stepId, userId: @userId})

Meteor.publish "Votes", (token) ->
  Votes.find({userToken: token})

Meteor.publish "TokenEmails", (token) ->
  TokenEmails.find({userToken: token})

Meteor.publish "VotesCountByAppAndBlueprint", (app, action) ->
  Counts.publish(@, "VotesCountByAppAndBlueprint", Votes.find({app: app, action, action}))
  []

Meteor.publish "Avatars", (api) ->
  check(api, String)
  return [] unless @userId
  Avatars.find({userId: @userId, api: api})

Meteor.publish "Credentials", (api) ->
  check(api, String)
  return []  unless @userId
  Credentials.find({userId: @userId, api: api}, {fields: {details: 0}})

Meteor.publish "StepData", (stepId, args...) ->
  check(stepId, Match.StringId)
  return [] unless @userId
  step = Steps.findOne(stepId, {transform: Transformations.Step})
  throw new Meteor.Error("Meteor.publish:StepData:step-not-found", "", {stepId: stepId}) if not step
  step.data(args...)
