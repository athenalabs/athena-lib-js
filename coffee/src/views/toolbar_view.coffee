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
      return @renderDropdownButtonFromObject button

    # render each button
    else if _.isObject(button)
      return @renderButtonFromObject button


  renderButtonFromObject: (button) =>
    btn = $ '<button>'
    btn.addClass 'btn'

    btn.append($("<i class='#{button.icon}'>")) if button.icon
    btn.append(' ') if button.text and button.icon
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


  renderDropdownButtonFromObject: (button) =>
    # generate the dropdown button element
    btn = $('<div class="btn-group">')
    btn.addClass(button.className) if button.className
    btn.attr('id', button.id) if button.id

    # generate the toggle element
    toggle = $('<button class="btn dropdown-toggle" data-toggle="dropdown">')
    toggle.append($("<i class='#{button.icon}'>")) if button.icon
    toggle.append(' ') if button.text and button.icon
    toggle.text(button.text) if button.text
    toggle.append " <i class='caret'>"
    btn.append toggle

    # generate all the dropdown list elements
    list = $('<ul class="dropdown-menu">')
    _.each button.dropdown, (button) =>
      item = $('<a href="#">')
      item.append($("<i class='#{button.leftIcon}'>")) if button.leftIcon
      item.text(button.text) if button.text
      item.append($("<i class='#{button.rightIcon}'>")) if button.rightIcon
      list.append $('<li>').append item
    btn.append list

    btn


  renderButtonGroup: (group) =>
    appendTo = $ '<div>'
    appendTo.addClass 'btn-group'

    _.each group, (btn) =>
      @renderButton(btn)?.appendTo(appendTo)

    appendTo
