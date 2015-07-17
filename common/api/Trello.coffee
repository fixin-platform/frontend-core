API.Trello =
  models:
    Card:
      fields: {}
    Checklist:
      fields:
        idCard: {kind: "foreignKey", model: "Card", field: "id", accessor: "card"}
    CheckItem:
      fields:
        idChecklist: {kind: "foreignKey", model: "Checklist", field: "id", accessor: "checklist"}
  init: ->
#    for model, definition of @models
#      definition.parent =

API.Trello.init()
