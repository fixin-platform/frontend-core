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
  pwd = cwd.substr(0, cwd.lastIndexOf("/.meteor"))
  touch "#{pwd}/tests/meteor.touch", {}, cb
