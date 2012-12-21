goog.provide 'athena.lib.App'
goog.require 'athena.lib.ContainerView'

# a self-contained application unit. Apps represent the top-level object,
# which contain a Router, a View, and any app-wide state, and logic.
class athena.lib.App

  # mixin Backbone.Events (not a class)
  _.extend @prototype, Backbone.Events

  constructor: (@options) ->
    @eventhub = @
    @initialize()

  # overridable classes for constructing app elements
  View: athena.lib.ContainerView
  Router: athena.lib.Router

  initialize: =>
    @view = new @View eventhub: @eventhub
    @router = new @Router eventhub: @eventhub

  showPage: (page) =>
    @view.content page
