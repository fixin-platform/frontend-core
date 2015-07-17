class Steps.LoadData extends Steps.SendMessage
  template: "LoadData"
  constructor: (config) ->
#    check config, Match.ObjectIncluding
#      api: String
#      scopes: [String]
    super
  revert: ->
    # TODO: clear data from database? (might not be the best decision for user, but otherwise UI shows that some files are already loaded; maybe implement the same completedSteps routine? completedSteps would also allow to optimize)
    # TODO: can't use completedSteps in all cases: for example, being connected to Google (= having a credential) shouldn't require manually completing a step
