goog.provide 'athena.lib.View'

# top level view for athena.lib
class athena.lib.View extends Backbone.View

  # Defaults for view options.
  defaults:

    # additional classes for the element
    extraClasses: []

    # Event aggregator (like NSNotificationCenter)
    eventhub: undefined

  initialize: ->
    super()

    # Extend options with defaults.
    _.defaults @options, @defaults

    # If no eventhub is provided, this object is used as the eventhub.
    this.eventhub = @options.eventhub || @

    # Bind all functions within this object (including functions defined in
    # derived classes) to `this`. This exempts you from having to bind
    # functions to their respective objects throughout the codebase.
    _.bindAll this

    # optionally add custom class names
    if @options.extraClasses
      _.each @options.extraClasses, (name) =>
        @$el.addClass name

  # Utility function for the complete removal of a View.
  destroy: ->
    @rendering = false
    @remove()
    @unbind()
    @uninitialize()

  # Whether this view should continue to rerender with updated information
  rendering: false

  # Render by default calls delegateEvents
  render: ->
    super()

    @rendering = true
    @delegateEvents()

  # Renders only if the view is in the ``rendering`` state.
  softRender: ->
    if @rendering
      @render()

  # Overridable function meant to mirror Backbone.View's initialize()
  uninitialize: ->