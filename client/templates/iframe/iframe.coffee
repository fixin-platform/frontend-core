appKey2Url =
  Trello: "https://trello.com/b/IbK5BeG5/welcome-board"
  Twitter: "https://twitter.com/followers"
  Freshdesk: "https://bellefit.freshdesk.com/helpdesk/tickets/206"

Template.iframe.helpers
  url: ->
    appKey2Url[Spire.getParam("appKey")]

Template.iframe.onCreated ->
  uri = new URI(appKey2Url[Spire.getParam("appKey")]);
  domain = uri.hostname()
  AdapterFactory.initIframe(domain)

Template.iframe.events
  "load iframe": (event, template) ->
    Spire.iframe = event.currentTarget
    Spire.window = Spire.iframe.contentWindow
    Spire.document = Spire.iframe.contentDocument
    AdapterFactory.handleLoadIframe()
