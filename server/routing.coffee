bodyParser = Npm.require("body-parser")

webhooks = Picker.filter (req, res) -> req.method is "POST"
webhooks.middleware(bodyParser.json())

webhooks.route "/webhooks/stripe", (params, request, response, next) ->
  body = request.body
  data = body.data
  object = data.object
  user = Users.findOne({stripeCustomerId: object.customer})
  if not user
    throw new Meteor.Error("user-not-found", "User not found by Stripe customer id", body)
  switch body.type
    when "charge.succeeded"
      # TODO: results in small undercharge: 1) User adds payment method 2) Some Jobs are run immediately 3) actions get decremented 4) hook gets called
      # TODO: a related undercharge issue: 1) User queues some Jobs 2) User queues more Jobs # in theory second queue should result in "Choose plan" popup, but the Jobs from the first queue hasn't processed yet. But those Jobs can result in failure, so we can't decrement actions right away. The solution here is to "lock" user actions and check only "free" action count
      actions = Math.max(0, user.actions) # may be positive in case of compensation for service outage
      Users.update(user._id, {$set: {actions: actions}}) # reset used actions counter upon successful charge
    when "customer.subscription.created", "customer.subscription.updated"
      Users.update(user._id, {$set: {planId: object.plan.id}})
    when "customer.subscription.deleted"
      Users.update(user._id, {$set: {planId: "free"}})
  response.writeHead(200)
  response.end()

Picker.route "/webhook/:_id", (params, req, res, next) ->
  check params,
    _id: Match.ObjectId(Steps)
    query: Object

  step = Steps.findOne(params._id)
  Commands.insert(
    isDryRun: false
    isShallow: false
    stepId: step._id
    userId: step.userId
    params: params.query
  )
  res.end()
