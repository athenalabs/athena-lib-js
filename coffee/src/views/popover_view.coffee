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
    $(@options.popover).popover
      animation: @options.animation
      placement: @options.placement
      # selector: @options.selector
      trigger: @options.trigger
      title: @options.title
      delay: @options.delay
      content: @$el

    # defer until parent in dom
    _.defer @initializePopover
    @


  initializePopover: =>
    unless $('html').find($(@options.popover))[0]
      throw new Error 'Error: popover not rendered correctly.'
      return

    # make sure popover is created
    $(@options.popover).popover('show').popover('hide')

    # handles to popover elem
    @$popoverEl = $(@options.popover).data('popover').$tip
    @popoverEl = @$popoverEl[0]

    @$contentEl = @$popoverEl.find('.popover-content')
    @contentEl = @$contentEl[0]

    @$contentEl.empty()
    @$contentEl.append @$el

    unless @options.title
      @$popoverEl.find('.popover-title').hide()
    @


  show: =>
    @$el.popover 'show'
    @$contentEl.empty()
    @$contentEl.append @$el


  hide: =>
    @$el.popover 'hide'


  toggle: =>
    @$el.popover 'toggle'


  destroy: =>
    @$el.popover 'destroy'
    super


# extend Popover prototype to allow selector content
console.log 'patching Popover'
Popover = $.fn.popover.Constructor
Popover::_setContent = Popover::setContent
Popover::setContent = ->
  console.log 'my setContent'
  $tip = @tip()
  title = @getTitle()
  content = @getContent()

  htmlOrText = if @options.html then 'html' else 'text'
  $tip.find('.popover-title')[htmlOrText](title)
  if content instanceof $
    $tip.find('.popover-content').empty()
    $tip.find('.popover-content').append content
  else
    $tip.find('.popover-content')[htmlOrText](content)

  $tip.removeClass('fade top bottom left right in')
