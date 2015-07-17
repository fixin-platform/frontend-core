class Columns.Formula extends Columns.Column
  constructor: (doc) ->
    super
  calculate: (row, columns) -> throw "Implement \"calculate\" method in Columns.#{@cls}"
  parse: (row, columns) ->
    args = []
    for argTemplate in @args
      for column in columns
        argTemplate = argTemplate.replace("{{#{column.name}}}", row[column.field])
      args.push(argTemplate)
    args

