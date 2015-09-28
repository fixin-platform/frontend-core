Steps.before.update (userId, doc, fieldNames, modifier, options) ->
  if modifier.$set?.isAutorun
    modifier.$set.refreshPlannedAt = new Date()

Steps.after.update (userId, doc, fieldNames, modifier, options) ->
  if @previous.isAutorun isnt doc.isAutorun
    Recipes.update(doc.recipeId, {$set: {isAutorun: doc.isAutorun}})

#Steps.before.update (userId, doc, fieldNames, modifier, options) ->
#  if modifier.$set?.isAutorun
#    # need to check Recipes, not Steps
#    user = Spire.currentUser({}, userId)
#    activeRecipesCount = Recipes.find({isAutorun: true, userId: userId}).count()
#    if activeRecipesCount + 1 > user.plan().activeRecipesLimit
#      throw new Meteor.Error(402, "Payment Required")
