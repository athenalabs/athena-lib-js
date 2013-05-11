goog.provide 'athena.lib.HeaderView'
goog.require 'athena.lib.DirectiveView'
goog.require 'athena.lib.ToolbarView'

# view for generating headers (directive + toolbar)
class athena.lib.HeaderView extends athena.lib.View


  className: @classNameExtend 'header-view'


  initialize: =>
    super
    @directiveView = new athena.lib.DirectiveView @options
    @toolbarView = new athena.lib.ToolbarView @options


  render: =>
    super
    @$el.empty()
    @$el.append @directiveView.render().el
    @$el.append @toolbarView.render().el
    @
