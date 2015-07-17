class Steps.ChooseOneOption extends Steps.Step
  template: "ChooseOneOption"
  constructor: (config) ->
    check config, Match.ObjectIncluding
      execute: Function
      revert: Function
    check config.optgroups or config.options, Function
    super
