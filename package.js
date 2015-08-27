var description = {
  summary: "Frontend Core",
  version: "1.0.0",
  name: "frontend-core"
};
Package.describe(description);

var path = Npm.require("path");
var fs = Npm.require("fs");
eval(fs.readFileSync("./packages/autopackage.js").toString());
Package.onUse(function(api) {
  addFiles(api, description.name, getDefaultProfiles());
  api.use(["meteor-platform", "coffeescript", "stylus", "mquandalle:jade@0.4.1", "underscore", "jquery", "reactive-var"]);
  api.use(["service-configuration", "accounts-base", "accounts-google", "accounts-twitter", "accounts-password"]);
  api.use(["reactive-dict"]);
  api.use(["oauth", "google", "twitter"]); // TODO: move them to appropriate packages
  api.use(["email", "http"]);
  //api.use(["force-ssl"]);
  api.use([
    "meteorhacks:kadira@2.20.0",
    //"kadira:zones@1.4.0", // Leads to 100% CPU hanging in extension
    "meteorhacks:fast-render@2.9.0",
    "meteorhacks:picker@1.0.2",
    "kadira:flow-router@2.1.1",
    "kadira:blaze-layout@2.0.1",
    "useraccounts:bootstrap@1.12.3",
    "useraccounts:flow-routing@1.12.3",
    "tmeasday:publish-counts@0.3.7"
  ], ["client", "server"]);
  api.use([
    "dburles:spacebars-tohtml@1.0.0"
  ], ["server"]);
  api.imply([
    "service-configuration", "accounts-base", "accounts-google", "accounts-twitter", "accounts-password", "google", "twitter", "reactive-var",
    "meteorhacks:fast-render", "meteorhacks:picker", "kadira:flow-router",
    "useraccounts:bootstrap", "useraccounts:flow-routing", "matb33:collection-hooks", "tmeasday:publish-counts"
  ]);

  // Local packages
  api.use([
    "frontend-foundation@1.0.0",
    "frontend-adapter@1.0.0",
    "frontend-checkmark@1.0.0"
  ]);
  api.imply([
    "frontend-foundation",
    "frontend-adapter",
    "frontend-checkmark"
  ]);

  api.export([
    "Pack",
    "API",
    "Barrier",
    "sanitizedProperties",
    "sanitize",
    "partializedAccessor",
    "holy",
    "Users",
    "Apps",
    "Blueprints",
    "Avatars",
    "Credentials",
    "Messages",
    "Recipes",
    "Steps",
    "Commands",
    "Issues",
    "TokenEmails",
    "Rows",
    "Columns",
    "Filters",
    "Votes",
    "Avatar",
    "Credential",
    "Task",
    "TaskRequirement",
    "TaskAvatar",
    "Order",
    "OrderItem",
    "insertData",
    "Logger",
    "t",
    "l",
    "nl",
    "Queue",
    "TokenEmails",
    "currentUserHandle",
    "allUsers",
    "AppsHandle",
    "BlueprintsHandle",
    "CredentialsHandle",
    "MessagesHandle",
    "AvatarSubscriptionIsInitialized",
    "StepDataSubscriptionHandles",
    "EditorCache",
    "Editor",
    "connect",
    "sendPageview",
    "currentUserToken",
    "createError",
    "Future",
    "Promise"
  ]);
  api.export([
    "mixpanel"
  ], ["server"]);
});

Npm.depends({
  "aws-sdk": "2.1.39",
  "bluebird": "2.9.25",
  "body-parser": "1.13.1",
  "request": "2.55.0",
  "flat": "1.5.0",
  "stripe": "3.1.0",
  "winston": "0.9.0",
  "winston-loggly": "1.0.4",
  "mixpanel": "0.0.20"
});
