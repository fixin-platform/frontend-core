Steps.before.update (userId, doc, fieldNames, modifier, options) ->
  if modifier.$set?.isAutorun
    modifier.$set.refreshPlannedAt = new Date()

Steps.after.update (userId, doc, fieldNames, modifier, options) ->
  if @previous.isAutorun isnt doc.isAutorun
    Recipes.update(doc.recipeId, {$set: {isAutorun: doc.isAutorun}})
