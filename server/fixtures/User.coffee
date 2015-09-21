Fixtures.push Meteor.users,
  CharlieDalton:
    profile:
      name: "Charlie Dalton"
      isRealName: true
    isAdmin: true
  KnoxOverstreet:
    profile:
      name: "Knox Overstreet"
      isRealName: true

Fixtures.pre Meteor.users, (users) ->
  lastWeek = new Date(Date.now() - 7 * 24 * 3600 * 1000)
  for _id, user of users
    _.defaults user,
      username: _id
      isNew: false
      isAliasedByMixpanel: true
      emails: [
        {
          address: _id.toLowerCase() + "@spirehq.com"
          verified: true
        }
      ]
      createdAt: lastWeek

Fixtures.post Meteor.users, (users) ->
  now = new Date()
  for _id, user of users
    Accounts.setPassword(_id, "123123")
    Users.update(_id, {$push: {"services.resume.loginTokens": {
      hashedToken: Accounts._hashLoginToken(_id),
      when: now
    }}})
