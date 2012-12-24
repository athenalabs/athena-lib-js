goog.provide 'athena.lib.ToolbarInputView'
goog.require 'athena.lib.InputView'

# view to render buttons in a form
class athena.lib.ToolbarInputView extends athena.lib.InputView


  className: @classNameExtend 'toolbar-input-view'


  tagName: 'div'


  defaults: => _.extend super,

    # the toolbar elements
    buttons: []


  initialize: =>
    super
    @toolbarView = new athena.lib.ToolbarView
      eventhub: @eventhub
      buttons: @options.buttons


  render: =>
    super
    @$el.empty()
    @$el.append @toolbarView.render().el
    @


  # override InputView::elAttributes with no additions
  elAttributes: => {}


  # store no value
  value: (value) =>
    undefined
