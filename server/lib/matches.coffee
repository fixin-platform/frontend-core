_.defaults(Match,
  StringId: Match.Where (value) ->
    check(value, String)
    if value in Fixtures.objectIds or Spire.isDebug
      return true # verbose IDs
    if value.length isnt 17 or _.difference(value.split(""), ["2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F", "G", "H", "J", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]).length
      throw new Match.Error("Value \"" + value + "\" is not a valid _id")
    true
  ObjectId: (collection, field = "_id") ->
    Match.Where (value) ->
      selector = {}
      selector[field] = value
      throw new Match.Error("Object #{JSON.stringify(selector)} doesn't exist in \"#{collection._name}\"") unless collection.findOne(selector)
      true
  UserId: Match.Where (value) ->
    check(value, Match.StringId)
    throw new Match.Error("User with ID \"" + value + "\" doesn't exist") unless Users.findOne(value)
    true
  InArray: (values) ->
    Match.Where (value) ->
      throw new Match.Error("Expected one of \""+values.join("\", \"")+"\"; got \"" + value + "\"") if value not in values
      true
  Is: (same) ->
    Match.Where (value) ->
      throw new Match.Error("Expected #{JSON.stringify(value)}=#{JSON.stringify(same)}") if value isnt same
      true
  UnsignedNumber: Match.Where (value) ->
    check(value, Number)
    throw new Match.Error("Must be unsigned number") if value < 0
    true
  EmptyArray: Match.Where (value) ->
    check(value, Array)
    throw new Match.Error("Must be empty array") if value.length > 0
    true
  Email: Match.Where (value) ->
    value.match(Spire.emailRegex)
  Url: Match.Where (value) ->
    value.length < 2083 && value.match(/^(?!mailto:)(?:(?:https?|ftp):\/\/)?(?:\S+(?::\S*)?@)?(?:(?:(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[0-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]+-?)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]+-?)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,})))|localhost)(?::\d{2,5})?(?:\/[^\s]*)?$/i);
)
