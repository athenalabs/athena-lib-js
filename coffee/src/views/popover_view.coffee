goog.provide 'athena.lib.PopoverView'
goog.require 'athena.lib.View'


# renders grid of views
class athena.lib.PopoverView extends athena.lib.ContainerView


  className: @classNameExtend 'popover-view'


  defaults: => _.extend super,
    trigger: 'click'
    delay: {show: 300, hide: 100}


  render: =>
    super
    @popover
      animation: @options.animation
      placement: @options.placement
      # selector: @options.selector
      trigger: @options.trigger
      title: @options.title
      delay: @options.delay
      content: @

    @


  popover: (options) =>
    $(@options.popover).popover options
    @


  show: =>
    @popover 'show'


  hide: =>
    @popover 'hide'


  toggle: =>
    @popover 'toggle'


  destroy: =>
    $(@options.popover).popover 'destroy'
    super


# extend Popover prototype to allow selector content
console.log 'patching Popover'
Popover = $.fn.popover.Constructor
Popover::_setContent = Popover::setContent
Popover::setContent = ->
  $tip = @tip()
  title = @getTitle()
  content = @getContent()

  htmlOrText = if @options.html then 'html' else 'text'

  if title
    $tip.find('.popover-title')[htmlOrText](title)
    $tip.find('.popover-title').show()
  else
    $tip.find('.popover-title').hide()

  if content instanceof Backbone.View
    $tip.find('.popover-content').empty()
    $tip.find('.popover-content').append content.render().$el
  else if content instanceof $
    $tip.find('.popover-content').empty()
    $tip.find('.popover-content').append content
  else
    $tip.find('.popover-content')[htmlOrText](content)


  $tip.removeClass('fade top bottom left right in')
