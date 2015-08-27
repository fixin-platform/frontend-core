Meteor.startup ->
  mixpanel.init(Meteor.settings.public.mixpanel.token,
    api_host: "https://api.mixpanel.com"
    loaded: mixpanelLoaded
  )
  if not Meteor.settings.public.mixpanel.isEnabled
    mixpanel.disable()
  else
    mixpanel.set_config({debug: Meteor.settings.public.isDebug})
  MixpanelInitializer(mixpanel)
