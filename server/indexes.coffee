try
  Users._dropIndex("emails.address_1")
catch error
  if error.toString() isnt "MongoError: index not found"
    Meteor._debug(error.stack)
Users._ensureIndex({"emails.address": 1}, {unique: true, dropDups: true, sparse: 1, background: true, name: "emails.address_1"})

Users._ensureIndex({username: 1}, {unique: true, dropDups: true, background: true})
Users._ensureIndex({friendUserIds: 1}, {background: true})

Apps._ensureIndex({key: 1}, {unique: true, dropDups: true, background: true})
Blueprints._ensureIndex({appId: 1, key: 1}, {unique: true, dropDups: true, background: true})

Steps._ensureIndex({recipeId: 1, key: 1}, {unique: true, dropDups: true, background: true})
Steps._ensureIndex({recipeId: 1}, {background: true})
Steps._ensureIndex({userId: 1}, {background: true})
Rows._ensureIndex({isReady: 1, stepId: 1, userId: 1}, {background: true})
Rows._ensureIndex({stepId: 1, userId: 1, jobId: 1}, {background: true})
Columns._ensureIndex({stepId: 1, userId: 1}, {background: true})
Filters._ensureIndex({stepId: 1, userId: 1}, {background: true})

Messages._ensureIndex({userId: 1}, {background: true})
Recipes._ensureIndex({userId: 1}, {background: true})

Votes._ensureIndex({app: 1, action: 1, userToken: 1}, {unique: true, dropDups: true, background: true})
TokenEmails._ensureIndex({userToken: 1}, {unique: true, dropDups: true, background: true})
