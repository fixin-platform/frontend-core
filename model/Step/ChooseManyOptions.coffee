class Steps.ChooseManyOptions extends Steps.Step
  template: "ChooseManyOptions"
  isMultiple: true
  constructor: (config) ->
    check config, Match.ObjectIncluding
      execute: Function
      revert: Function
    check config.optgroups or config.options, Function
    super
  isSelected: -> throw "Implement \"isSelected\" method in your step"
  selectizeOptions: ->
    lockOptgroupOrder: true
#    maxItems: Infinity
