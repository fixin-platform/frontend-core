class Columns.ConcatFormula extends Columns.Formula
  constructor: (doc) ->
    super
  calculate: (row, columns) ->
    row[@field] # temp
