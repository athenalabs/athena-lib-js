goog.provide 'athena.lib.ModalView'
goog.require 'athena.lib.View'
goog.require 'athena.lib.util.keys'

# base class for fields of different types
class athena.lib.ModalView extends athena.lib.View


  className: @classNameExtend 'modal-view modal hide'


  defaults: => _.extend super,
    title: ''
    closeButtonName: 'Close'
    show: false
    fadeIn: true
    fadeOut: false
    backdrop: true # if 'static', don't close on backdrop clicks


  events: => _.extend super,
    'show': @_onShowEvent
    'shown': @_onShownEvent
    'hide': @_onHideEvent
    'hidden': @_onHiddenEvent
    'click .dismiss-modal': @_onClickDismissModal


  template: _.template '''
    <div class="modal-header">
      <button type="button" class="close dismiss-modal">×</button>
      <h3 class="modal-title"><%= title %></h3>
    </div>
    <div class="modal-body"></div>
    <div class="modal-footer">
      <a href="#" class="btn dismiss-modal"><%= closeButtonName %></a>
    </div>
    '''


  render: =>
    super

    @$el.empty()
    @$el.append @template
      title: @options.title
      closeButtonName: @options.closeButtonName

    @$el.modal
      show: @options.show # whether to show the modal initially
      keyboard: false # use our own keyboard events
      backdrop: 'static' # use our own backdrop.click event

    @


  show: =>
    @$el.modal 'show'


  hide: =>
    @$el.modal 'hide'


  # echo bootstrap events at proper timing with respect to internal handling
  _onShowEvent: =>
    @trigger 'show'
    @_onShow()
  _onShownEvent: =>
    @_onShown()
    @trigger 'shown'
  _onHideEvent: =>
    @trigger 'hide'
    @_onHide()
  _onHiddenEvent: =>
    @_onHidden()
    @trigger 'hidden'


  _onShow: =>
    # adjust .fade class
    if @options.fadeIn
      @$el.addClass 'fade'
    else
      @$el.removeClass 'fade'


  _onShown: =>
    # bind keyup and backdrop click events
    $(document).bind 'keyup.athena-lib-modal', @_onGlobalKeyup
    $('.modal-backdrop').bind 'click.athena-lib-modal', @_onClickBackdrop


  _onHide: =>
    # unbind keyup and backdrop click events
    $(document).unbind 'keyup.athena-lib-modal'
    $('.modal-backdrop').unbind 'click.athena-lib-modal'

    # adjust .fade class on @$el and backdrop
    if @options.fadeOut
      @$el.addClass 'fade'
      $('.modal-backdrop.in').addClass 'fade'
    else
      @$el.removeClass 'fade'
      $('.modal-backdrop.in').removeClass 'fade'


  _onHidden: =>


  _onGlobalKeyup: (e) =>
    switch e.keyCode
      when athena.lib.util.keys.ENTER then @_onGlobalKeyupEnter()
      when athena.lib.util.keys.ESCAPE then @_onGlobalKeyupEscape()

    false


  _onGlobalKeyupEnter: =>
    @hide()


  _onGlobalKeyupEscape: =>
    @hide()


  _onClickDismissModal: =>
    @hide()


  _onClickBackdrop: =>
    unless @options.backdrop == 'static'
      @hide()
