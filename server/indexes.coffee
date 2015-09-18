try
  Users._dropIndex("emails.address_1")
catch error
  if error.toString() isnt "MongoError: index not found"
    Meteor._debug(error.stack)
Users._ensureIndex({"emails.address": 1}, {unique: true, dropDups: true, sparse: 1, background: true, name: "emails.address_1"})

Users._ensureIndex({username: 1}, {unique: true, dropDups: true, background: true})
Users._ensureIndex({friendUserIds: 1}, {background: true})

Steps._ensureIndex({recipeId: 1, key: 1}, {unique: true, dropDups: true, background: true})
Steps._ensureIndex({recipeId: 1}, {background: true})
Steps._ensureIndex({userId: 1}, {background: true})

Recipes._ensureIndex({userId: 1}, {background: true})

Votes._ensureIndex({app: 1, action: 1, userToken: 1}, {unique: true, dropDups: true, background: true})
TokenEmails._ensureIndex({userToken: 1}, {unique: true, dropDups: true, background: true})
