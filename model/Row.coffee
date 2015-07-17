Transformations["Row"] = (object) -> Transformations.static(Rows.Row, object)
Rows = Collections["Row"] = new Mongo.Collection("Rows", {transform: if Meteor.isClient then Transformations.Row else null})

class Rows.Row
  constructor: (doc) ->
    _.extend(@, doc)
  buildSearchString: ->
    JSON.stringify(_.omit(@, ["createdAt", "updatedAt", "jobId", "stepId", "userId"]))
