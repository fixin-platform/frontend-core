requestAsync = Promise.promisify(Npm.require("request"))
#Promise.promisifyAll(requestAsync)
#limit = Npm.require("simple-rate-limiter")
#request = limit(Meteor.bindEnvironment(request, "Jobs.ShipStationJob::request")).to(40).per(Foreach.minute)

class Bindings.Request extends Bindings.Binding
  request: (options) ->
    requestAsync(options)
    .bind(@)
    .spread (response, body) ->
      @checkResponse(response, body)
      [response, body]

  checkResponse: (response, body) ->
    if response.statusCode isnt 200
      details = {}
      for key, value of response when not _.isObject(value) and not _.isFunction(value) and not _.isArray(value)
        details[key] = value
      details.body = body
      throw new Meteor.Error("Request:failed", "An error occurred during request to server", details)
