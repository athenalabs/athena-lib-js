goog.provide 'athena.lib.ToolbarView'
goog.require 'athena.lib.View'


# view for generating and containing buttons
class athena.lib.ToolbarView extends athena.lib.View


  className: @classNameExtend 'toolbar-view'


  events: => _.extend super,
    'click button:not(.dropdown-toggle)': (event) =>
      target = event.target
      target = target.parentNode if target.tagName is 'I'

      if target.id
        @trigger "Toolbar:Click:#{target.id}", @, event
      @trigger "Toolbar:Click", @, event

    'click .dropdown-toggle': (event) =>
      target = event.target
      target = target.parentNode if target.tagName is 'I'

      dropdown_id = $(target).closest('.btn-group').attr('id')
      if dropdown_id
        @trigger "Toolbar:Click:#{dropdown_id}", @, event
      @trigger "Toolbar:Click", @, event

    'click .dropdown-link': (event) =>
      target = event.target
      target = target.parentNode if target.tagName is 'I'

      dropdown_id = $(target).closest('.btn-group').attr('id')
      if target.id and dropdown_id
        @trigger "Toolbar:Click:#{dropdown_id}:#{target.id}", @, event
      if target.id
        @trigger "Toolbar:Click:#{target.id}", @, event
      @trigger "Toolbar:Click", @, event


  initialize: =>
    super
    @buttons = @options.buttons || []


  button: (btnid) =>
    foundBtns = []
    searchButtons = (buttons, btnid) =>
      _.each buttons, (btn) =>
        if _.isArray btn
          searchButtons btn, btnid
        else if btn.id is btnid
          foundBtns.push btn

    searchButtons @buttons, btnid
    foundBtns.shift()


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
    toggle.append(button.text) if button.text
    toggle.append " <i class='caret'>"
    btn.append toggle

    # generate all the dropdown list elements
    list = $('<ul class="dropdown-menu">')
    _.each button.dropdown, (button) =>
      item = $('<a href="#" class="dropdown-link">')
      item.attr('id', button.id) if button.id
      item.append($("<i class='#{button.leftIcon}'>")) if button.leftIcon
      item.append(button.text) if button.text
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
