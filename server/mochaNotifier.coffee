touch = Npm.require "touch"
Future = Npm.require "fibers/future"

# TODO: run this only in development mode
#Package.describe({
#  debugOnly: true
#});

# client refreshed
process.on "message", (message) ->
  return unless message.refresh is "client"
  notifyMocha()

# server refreshed
WebApp.onListening ->
  future = new Future()
  notifyMocha(future.resolver())
  future.wait()

notifyMocha = (cb) ->
  cwd = process.cwd()
  meteorDirIndex = cwd.lastIndexOf("/.meteor")
  return if not ~meteorDirIndex # we're in production, baby!
  pwd = cwd.substr(0, meteorDirIndex)
  touch "#{pwd}/tests/meteor.touch", {}, cb
