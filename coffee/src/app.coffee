goog.provide 'athena.lib.App'
goog.require 'athena.lib.PageView'
goog.require 'athena.lib.MixpanelTracker'
goog.require 'athena.lib.NullTracker'

# a self-contained application unit. Apps represent the top-level object,
# which contain a Router, a View, and any app-wide state, and logic.
class athena.lib.App


  # mixin Backbone.Events (not a class)
  _.extend @prototype, Backbone.Events


  constructor: (@options) ->
    @eventhub = @
    @initialize()


  # overridable classes for constructing app elements
  View: athena.lib.PageView
  Router: athena.lib.Router


  initialize: =>
    @view = new @View eventhub: @eventhub
    @router = new @Router eventhub: @eventhub, app: @

    @initializeAnalytics()


  initializeAnalytics: =>

    if config?

      # mixpanel config
      if config.MIXPANEL_TOKEN?
        mixpanel_token = config.MIXPANEL_TOKEN
        @mixpanel = new athena.lib.MixpanelTracker mixpanel_token

      # google analytics config
      if config.GOOGLE_ANALYTICS_TRACKER_ID?
        ga_tracker_id = config.GOOGLE_ANALYTICS_TRACKER_ID
        @ga = new athena.lib.GoogleAnalyticsTracker ga_tracker_id

    if not @mixpanel?
      @mixpanel = new athena.lib.NullTracker()

    if not @ga?
      @ga = new athena.lib.NullTracker()


  showPage: (page) =>
    @view.content page
    unless @view.rendering
      @view.render()


  start: =>
    Backbone.history.start {pushState: true}
