process.env.MAIL_URL = Meteor.settings.mailUrl or process.env.MAIL_URL
Accounts.emailTemplates.siteName = "Foreach"
Accounts.emailTemplates.from = "Foreach <accounts@foreach.pintask.me>"

AccountsTemplates.configure
  overrideLoginErrors: false
