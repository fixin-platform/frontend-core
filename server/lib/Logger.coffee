util = Npm.require("util")
winston = Npm.require("winston")
loggly = Npm.require('winston-loggly');
url = Npm.require("url")
hostname = url.parse(Meteor.settings.baseUrl).hostname

winston.addColors(
  verbose: "green"
)

transports = []

if Meteor.settings.loggly
  transportLoggly = new winston.transports.Loggly(_.extend(
    json: true
  , Meteor.settings.loggly
  ))
  _.extend(transportLoggly,
    level: "debug"
    handleExceptions: true
    exitOnError: false
  )
  transports.push(transportLoggly)

transportConsole = new winston.transports.Console(
  level: "info"
  prettyPrint: true
  colorize: true
  showLevel: false
  silent: not Meteor.settings.public.isDebug
  handleExceptions: true
  exitOnError: false
)
transports.push(transportConsole)

Logger = new winston.Logger(
  transports: transports
)
Logger.addRewriter (level, msg, meta) ->
  sanitize(meta)

formatArgs = (args) ->
  [util.format.apply(util.format, Array::slice.call(args))]

Meteor._debug = ->
  Logger.error.apply Logger, formatArgs(arguments)

l = _.bind(Logger.debug, Logger)
nl = _.bind(Logger.info, Logger)
