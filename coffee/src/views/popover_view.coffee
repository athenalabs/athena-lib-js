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

    @showing = false

    @popover
      animation: @options.animation
      placement: @options.placement
      # selector: @options.selector
      trigger: @options.trigger
      title: @options.title
      delay: @options.delay
      placementOffset: @options.placementOffset
      content: @

    @


  popover: (options) =>
    $(@options.popover).popover options
    @


  show: =>
    unless @rendering
      return

    @popover 'show'
    @showing = true
    @trigger 'PopoverView:PopoverDidShow'


  hide: =>
    unless @rendering
      return

    @popover 'hide'
    @showing = false
    @trigger 'PopoverView:PopoverDidHide'


  toggle: =>
    unless @rendering
      return

    # bootstrap has a bug in toggle, so for now toggle manually. bug is tracked
    # here: https://github.com/lecar-red/bootstrapx-clickover/issues/21
    if @showing then @popover 'hide' else @popover 'show'
    @showing = !@showing
    @trigger "PopoverView:PopoverDid#{if @showing then 'Show' else 'Hide'}"


  destroy: =>
    $(@options.popover).popover 'destroy'
    super


# extend Popover prototype to allow selector content and adjustable placement
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

# adjust popover placement based on custom placementOffset option
Popover::_applyPlacement = Popover::applyPlacement
Popover::applyPlacement = (offset, placement) ->
  adjustedOffset =
    top: offset.top + (@options.placementOffset.top ? 0)
    left: offset.left + (@options.placementOffset.left ? 0)
  @_applyPlacement adjustedOffset, placement

# adjust arrow placement based on custom placementOffset option
Popover::_replaceArrow = Popover::replaceArrow
Popover::replaceArrow = (delta, dimension, position) ->
  # adjust delta by 2 * offset (delta gets halved later) before forwarding
  offset = @options.placementOffset ? {}
  adjustment = if position == 'top' then offset.top else offset.left
  @_replaceArrow delta + (2 * adjustment ? 0), dimension, position

# patch bootstrap bug: native method incorrectly looks for '.tooltip-arrow'
Popover::arrow = ->
  @$arrow = @$arrow or @tip().find '.arrow'
