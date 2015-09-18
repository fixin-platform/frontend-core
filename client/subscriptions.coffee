currentUserHandle = Meteor.subscribe("currentUser")
allUsers = Meteor.subscribe("allUsers")

if currentUserToken
  @VotesHandle = Meteor.subscribe("Votes", currentUserToken)
  @TokenEmailsHandle = Meteor.subscribe("TokenEmails", currentUserToken)
else
  throw new Meteor.Error("foreach-owner-token-not-found")

AvatarSubscriptionIsInitialized = new ReactiveDict("AvatarSubscriptionIsInitialized")
StepDataSubscriptionHandles = {}
