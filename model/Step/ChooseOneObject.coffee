class Steps.ChooseOneObject extends Steps.Step
  template: "ChooseOneObject"
  constructor: (config) ->
    check config, Match.ObjectIncluding
      key: Function
      value: Function
      execute: Function
      revert: Function
    check config.optgroups or config.options, Function
    super
