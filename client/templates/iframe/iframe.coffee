appKey2Url =
  Trello: "https://trello.com/b/IbK5BeG5/welcome-board"
  Twitter: "https://twitter.com/followers"
  Freshdesk: "https://bellefit.freshdesk.com/helpdesk/tickets/206"

Template.iframe.helpers
  url: ->
    appKey2Url[Foreach.getParam("appKey")]

Template.iframe.onCreated ->
  uri = new URI(appKey2Url[Foreach.getParam("appKey")]);
  domain = uri.hostname()
  AdapterFactory.initIframe(domain)

Template.iframe.events
  "load iframe": (event, template) ->
    Foreach.iframe = event.currentTarget
    Foreach.window = Foreach.iframe.contentWindow
    Foreach.document = Foreach.iframe.contentDocument
    AdapterFactory.handleLoadIframe()
