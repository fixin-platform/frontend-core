process.env.MAIL_URL = Meteor.settings.mailUrl or process.env.MAIL_URL
Accounts.emailTemplates.siteName = Meteor.settings.public.name
Accounts.emailTemplates.from = "#{Meteor.settings.public.name} Support <support@#{Meteor.settings.baseUrl}>"

AccountsTemplates.configure
  overrideLoginErrors: false
