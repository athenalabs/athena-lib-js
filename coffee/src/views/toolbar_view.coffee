goog.provide 'athena.lib.ToolbarView'

goog.require 'athena.lib.View'

# view for generating and containing buttons
class athena.lib.ToolbarView extends athena.lib.View

  className: @classNameExtend 'toolbar-view'

  initialize: =>
    super
    @buttons = @options.buttons ? []

  render: =>
    super
    @$el.empty()
    _.each @buttons, @renderButton
    @

  renderButton: (button) =>
    # append views.
    if button instanceof Backbone.View
      @$el.append button.render().el

    # append selectors
    else if button instanceof $
      @$el.append button

    # bootstrap btn-toolbar from array
    else if _.isArray button
      # TODO implement bootstrap btn-toolbar setup.

    # bootstrap btn-group (dropdown) from object
    else if _.isObject(button) && _.isArray button.dropdown
      # TODO implement renderDropdownButtonObject
      # @renderDropdownButtonObject button

    # render each button
    else if _.isObject(button)
      @$el.append @buttonFromObject button

  buttonFromObject: (button) =>
    btn = $ '<button>'
    btn.addClass 'btn'
    btn.text button.text

    btn.addClass(button.className) if button.className
    btn.attr('id', button.id) if button.id

    _.each (button.events ? {}), (callback, eventName) =>
      btn.on eventName, callback

    btn
