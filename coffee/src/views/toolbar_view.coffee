goog.provide 'athena.lib.ToolbarView'

goog.require 'athena.lib.View'

# view for generating and containing buttons
class athena.lib.ToolbarView extends athena.lib.View

  className: @classNameExtend 'toolbar-view'

  initialize: =>
    super
    @buttons = @options.buttons || []

  render: =>
    super
    @$el.empty()
    @$el.append @renderButtonGroup(@buttons).children()
    @

  renderButton: (button) =>

    # append views.
    if button instanceof Backbone.View
      return button.render().$el

    # append selectors
    else if button instanceof $
      return button

    # construct button objects from strings
    else if _.isString button
      return @renderButtonFromObject {text: button}

    # bootstrap btn-toolbar from array
    else if _.isArray button
      return @renderButtonGroup button

    # bootstrap btn-group (dropdown) from object
    else if _.isObject(button) && _.isArray button.dropdown
      # TODO implement renderDropdownButtonObject
      # @renderDropdownButtonObject button

    # render each button
    else if _.isObject(button)
      return @renderButtonFromObject button

  renderButtonFromObject: (button) =>
    btn = $ '<button>'
    btn.addClass 'btn'

    btn.append($("<i class='#{button.icon}'>")) if button.icon
    btn.append(button.text) if button.text

    btn.addClass(button.className) if button.className
    btn.attr('id', button.id) if button.id

    if button.tooltip
      tooltip = button.tooltip
      tooltip = {title: button.tooltip} if _.isString(tooltip)
      btn.tooltip tooltip

    _.each (button.events ? {}), (callback, eventName) =>
      btn.on eventName, callback

    btn

  renderButtonGroup: (group) =>
    appendTo = $ '<div>'
    appendTo.addClass 'btn-group'

    _.each group, (btn) =>
      @renderButton(btn)?.appendTo(appendTo)

    appendTo
