Kadira.errors.addFilter Kadira.errorFilters.filterCommonMeteorErrors
Kadira.errors.addFilter (errorType, message, error) ->
  if error instanceof Meteor.Error and error.error in ["User:noStripeCustomer", "User:noStripeSources", "Payment Required"]
    return false
  return true
