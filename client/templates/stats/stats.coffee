usersort = {createdAt: -1, _id: -1}

Template.stats.helpers
  usersForStats: ->
#    sort = {"stats.Trello": -1}
    Users.find({}, {sort: usersort, transform: Transformations.User})
  flagset: ->
    [
      name: "Contacted"
      icon: "envelope"
    ,
      name: "InterestedInCustomVersion"
      icon: "dollar"
    ,
      name: "IsDuplicate"
      icon: "venus-double"
    ,
      name: "GarbageCollected"
      icon: "recycle"
      isImportant: true
    ]
  actionsPlusStatsTrello: ->
    @actions + (@stats?.Trello or 0)

Template.stats.onRendered ->

Template.stats.events
  "click .toggle-flag": encapsulate (event, template) ->
    $target = $(event.currentTarget)
    $target.blur()
    user = Users.findOne($target.attr("data-id"))
    if @name in user.flags
      modifier = {$pull: {flags: @name}}
    else
      modifier = {$addToSet: {flags: @name}}
    Users.update(user._id, modifier)
  "click .download-csv": grab encapsulate (event, template) ->
    $target = $(event.currentTarget)
    rows = [["Email", "Firstname", "Lastname", "CreatedAt"]]
    selector = {flags: {$nin: ["Contacted", "IsDuplicate", "GarbageCollected"]}, isInternal: {$not: true}, isAdmin: {$not: true}}
    selector["profile.isRealName"] = if $target.attr("data-is-real-name") then true else {$not: true}
    Users.find(selector, {sort: usersort, transform: Transformations.User}).forEach (user) ->
      rows.push toCSV [
        user.emails[0].address
        user.firstName
        user.lastName
        moment(user.createdAt).format("MMM DD, HH:mm")
      ]
    csv = rows.join("\n")
    encodedUri = "data:text/csv;charset=utf-8," + encodeURI(csv)
    link = document.createElement("a")
    link.setAttribute "href", encodedUri
    link.setAttribute "download", "Prospects - #{moment().format("HH:mm:ss")}.csv"
    document.body.appendChild(link)
    link.click()
  "click .upload-csv": grab encapsulate (event, template) ->
    template.$(".processed-prospects").click()
  "change .processed-prospects": grab encapsulate (event, template) ->
    for file in event.currentTarget.files
      reader = new FileReader()
      reader.onload = (e) =>
        rows = $.csv.toArrays(e.target.result)
        rows.shift() # header
        for row in rows
          email = row[0]
          user = Users.findOne({"emails.address": email})
          if not user
            alert("User \"#{email}\" not found")
            return
          Users.update(user._id, {$addToSet: {flags: "Contacted"}})
        alert("Marked #{rows.length} users as \"Contacted\"")
      reader.readAsText(file)
  "click .set-name": grab encapsulate (event, template) ->
    name = prompt(@emails[0].address, @profile.name)
    return if not name # may be null if user cancelled the prompt
    name = name.trim()
    Users.update(@_id, {$set: {"profile.name": name}})
  "click .autofix-name": grab encapsulate (event, template) ->
    name = Users.findOne(@_id).profile.name
    name = _.map(name.toLowerCase().split(/[^\w]/), (splinter) -> splinter[0].toUpperCase() + splinter.substr(1)).join(" ")
    Users.update(@_id, {$set: {"profile.name": name}})
  "click .toggle-is-real-name": grab encapsulate (event, template) ->
    isRealName = Users.findOne(@_id).profile.isRealName
    Users.update(@_id, {$set: {"profile.isRealName": not isRealName}})
  "click .sync-user-with-mixpanel": grab encapsulate (event, template) ->
    Meteor.call("syncWithMixpanel", @_id, Spire.handleError (error, emails) ->
      alert("Added #{emails.join(", ")}")
    )
