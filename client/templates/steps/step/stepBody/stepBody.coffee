@stepBodyHelpers =
  isLoading: (selector) ->
    step = Template.instance().data
    commands = Commands.find(_.defaults({stepId: step._id}, selector)).fetch()
    for command in commands
      return true if not command.enqueuedTaskIds.length # Command not processed by server yet => Command is loading
      return true if not command.failedTaskIds.length and _.difference(command.enqueuedTaskIds, command.succeededTaskIds, command.failedTaskIds).length # One of Command tasks has not been completed yet, and there are no errors yet
    return false
  isLoadingRefreshSelector: ->
    isDryRun: true
    isShallow: false
    rowId: {$exists: false}
  isLoadingAllRowsSelector: ->
    isDryRun: false
    isShallow: true
    rowId: {$exists: false}
  isLoadingSingleRowSelector: ->
    isDryRun: false
    isShallow: true
    rowId: @_id
  commandDryRun: ->
    Commands.findOne({isDryRun: true, rowId: {$exists: false}}, {sort: {createdAt: -1}})
  commandForAllRows: ->
    Commands.findOne({isDryRun: false, isShallow: true, rowId: {$exists: false}}, {sort: {createdAt: -1}})
  commandForSingleRow: ->
    Commands.findOne({isDryRun: false, isShallow: true, rowId: @_id}, {sort: {createdAt: -1}})
  shownColumns: ->
    step = Template.instance().data
    _.filter(step.columns(), (column) => column.key not in step.hiddenColumnKeys)
  rows: ->
    Rows.find({stepId: @_id}, {sort: {sort: 1, createdAt: -1}})
  count: ->
    Counts.get("RowsCountByStepId")
  stringify: (object) ->
    EJSON.stringify(object[@], {indent: true})
  data: ->
    row: Template.parentData(1)
    column: Template.currentData()
  progressBarMessage: (step) ->
    # isFinished has priority (so that isStarted = false & isFinished = true displays OK)
    key = step._i18nKey() + ".progressBars.#{@activityId}"
    if @total
      suffix = "total"
      count = @total # "Downloaded 1 of 4 Twitter followers" <- "followers", because 4 total
    else
      suffix = "current"
      count = @current
    if @isFinished
      key += ".loaded_#{suffix}"
    else
      if @isStarted
        if count
          key += ".loading_#{suffix}"
        else
          key += ".connecting"
      else
        key += ".waiting"
    i18n.t(key, _.extend({count: count}, @))
  progressBarIconClass: ->
    if @isFinished then "fa-check" else "fa-ellipsis-h"

Template.stepBody.helpers(stepBodyHelpers)

@stepBodyOnCreated = ->
  stepId = @data._id
  @subscribe("CommandsByStepId", stepId)
  @autorun =>
    step = Steps.findOne(stepId, {fields: {page: 1, search: 1}})
    @subscribe("RowsByStepId", stepId, step.page, 0, step.search)
  @autorun =>
    step = Steps.findOne(stepId, {fields: {search: 1}})
    @subscribe("RowsCountByStepId", stepId, step.search)

Template.stepBody.onCreated(stepBodyOnCreated)

@stepBodyEvents =
  "submit .refresh-form": grab encapsulate (event, template) ->
    $form = $(event.currentTarget)
    $form.find("button").blur() # restore button appearance
    step = Template.instance().data
    step.insertCommand
      isDryRun: true
      isShallow: false
  "change .run-mode input": grab encapsulate (event, template) ->
    step = Template.instance().data
    isAutorun = $(event.currentTarget).val() is "auto"
    Steps.update(step._id, {$set: {isAutorun: isAutorun}})
  "click .run-for-all-rows": grab encapsulate (event, template) ->
    step = Template.instance().data
    $(event.currentTarget).blur()
    step.insertCommand
      isDryRun: false
      isShallow: true
  "click .run-for-single-row": grab encapsulate (event, template) ->
    step = Template.instance().data
    step.insertCommand
      isDryRun: false
      isShallow: true
      rowId: @_id
  "click .cancel": grab encapsulate (event, template) ->
    Commands.find({stepId: @_id}).forEach (command) ->
      Commands.remove(command._id)

Template.stepBody.events(stepBodyEvents)
