Steps.after.update (userId, doc, fieldNames, modifier, options) ->
  if @previous.isAutorun isnt doc.isAutorun
    Recipes.update(doc.recipeId, {$set: {isAutorun: doc.isAutorun}})
