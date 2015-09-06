Template.ChooseManyOptions.helpers
  isMultiple: -> true
  isSelected: -> throw "Implement \"isSelected\" method in your step"
  selectizeOptions: ->
    lockOptgroupOrder: true
#    maxItems: Infinity

Template.ChooseManyOptions.onCreated ->

Template.ChooseManyOptions.events
#  "click .selector": (event, template) ->
