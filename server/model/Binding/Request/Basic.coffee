class Bindings.Basic extends Bindings.Request
  request: (options) ->
    _.defaults(options,
      headers: {}
    )
    _.defaults(options.headers,
      'Authorization': @generateAuthorizationHeader()
    )
    super(options)

  generateAuthorizationHeader: ->
    credential = @credential
    raw = credential.details.username + ":" + credential.details.password
    "Basic " + @encrypt raw

  encrypt: (string) ->
    new Buffer(string).toString('base64')
