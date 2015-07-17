Foreach.fixtureIds = []

# @return Array of inserted _id's
insertData = (data, collection, reloadedCollectionNames) ->
  for _id, object of data when _id not in Foreach.fixtureIds
    Foreach.fixtureIds.push(_id)
  return [] if collection._name not in reloadedCollectionNames and reloadedCollectionNames.length
  return [] if collection.find().count()
  for _id, object of data
    object._id = _id
    object.isNew = false
    object.isFixture = true
    collection.insert(object)
