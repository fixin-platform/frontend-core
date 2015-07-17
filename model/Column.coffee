Transformations["Column"] = (object) -> Transformations.dynamic(Columns, Columns.Column, object)
Columns = Collections["Column"] = new Mongo.Collection("Columns", {transform: if Meteor.isClient then Transformations.Column else null})

class Columns.Column
  constructor: (config) ->
    _.extend(@, config)
    _.defaults(@,
      template: "Column"
      isVisible: true
    )
    @field or= @key
    @name or= @field
  format: (value) -> value
  search: (row) -> @value(row)?.toString()
  value: (row) -> @format(row[@field])
  filters: (options) ->
    Filters.find({columnId: @_id}, options)

ColumnPreSave = (userId, changes) ->
  now = new Date()
  changes.updatedAt = changes.updatedAt or now

Columns.before.insert (userId, Column) ->
  Column._id ||= Random.id()
  now = new Date()
  LastColumn = Columns.findOne({stepId: Column.stepId}, {sort: {position: -1}})
  _.defaults(Column,
    name: ""
    cls: "Column"
    isHidden: false
    position: if LastColumn then LastColumn.position + 1 else 1
    stepId: ""
    isRemovable: true
    userId: userId
    updatedAt: now
    createdAt: now
  )
  throw new Meteor.Error("Column:userId:empty", "Column::userId is empty", Column) if not Column.userId
  ColumnPreSave.call(@, userId, Column)
  true

Columns.before.update (userId, Column, fieldNames, modifier, options) ->
  modifier.$set = modifier.$set or {}
  ColumnPreSave.call(@, userId, modifier.$set)
  true
