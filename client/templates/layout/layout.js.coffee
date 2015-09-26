Template.layout.helpers
  headerTemplate: -> @headerTemplate or "header"
  footerTemplate: -> @footerTemplate or "footer"
  subfooterTemplate: -> @subfooterTemplate or "subfooter"

Template.layout.onRendered ->

Template.layout.events
