Transformations["Filter"] = (object) -> Transformations.static(Filters.Filter, object)
Filters = Collections["Filter"] = new Mongo.Collection("Filters", {transform: if Meteor.isClient then Transformations.Filter else null})

class Filters.Filter
  constructor: (doc) ->
    _.extend(@, doc)
  column: ->
    Columns.findOne(@foreachColumnId)

FilterPreSave = (userId, changes) ->
  now = new Date()
  changes.updatedAt = changes.updatedAt or now

Filters.before.insert (userId, Filter) ->
  Filter._id ||= Random.id()
  now = new Date()
  _.defaults(Filter,
    cls: ""
    position: 0
    columnId: ""
    stepId: ""
    isRemovable: true
    userId: userId
    updatedAt: now
    createdAt: now
  )
  if not Filter.stepId
    column = Columns.findOne(Filter.columnId)
    throw new Meteor.Error("column-not-found", "Can't find Column for Filter ##{Filter._id}", Filter) if not column
    Filter.stepId = column.stepId # to simplify subscription; may become obsolete if we implement a spinner in place of a cog while we load the column header
  if not Filter.position
    LastFilter = Filters.findOne({columnId: Filter.columnId}, {sort: {position: -1}})
    Filter.position = if LastFilter then LastFilter.position + 1 else 1
  throw new Meteor.Error("Filter:userId:empty", "Filter::userId is empty", Filter) if not Filter.userId
  FilterPreSave.call(@, userId, Filter)
  true

Filters.before.update (userId, Filter, fieldNames, modifier, options) ->
  modifier.$set = modifier.$set or {}
  FilterPreSave.call(@, userId, modifier.$set)
  true
