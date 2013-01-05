goog.provide 'athena.lib.TextareaInputView'
goog.require 'athena.lib.InputView'

# base class for fields of different types
class athena.lib.TextareaInputView extends athena.lib.InputView


  className: @classNameExtend 'textarea-input-view'


  tagName: 'textarea'


  defaults: => _.extend super,
    rows: 3


  elAttributes: =>
    placeholder: @options.placeholder
    rows: @options.rows
    value: @value()
