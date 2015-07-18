class Bindings.Binding
  constructor: (options) ->
    check options, Match.ObjectIncluding
      avatar: Object
      scopes: [String]
    _.extend(@, options)
    @credential = _.find(@avatar.Credentials, (credential) => not _.difference(@scopes, credential.scopes).length) # no need to filter by expiresAt, because if there's a refreshToken, the credential will be refreshed automatically
    check(@credential, Object)
