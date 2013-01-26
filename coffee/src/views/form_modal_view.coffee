goog.provide 'athena.lib.FormModalView'
goog.require 'athena.lib.ModalView'
goog.require 'athena.lib.TextareaInputView'
goog.require 'athena.lib.FormComponentView'
goog.require 'athena.lib.FormView'

# base class for fields of different types
class athena.lib.FormModalView extends athena.lib.ModalView


  className: @classNameExtend 'form-modal-view'


  defaults: => _.extend super,
    title: 'Form'
    closeButtonName: 'Cancel'
    submitButtonName: 'Submit'


  events: => _.extend super,
    'click .submit': => @_submit()


  initialize: =>
    super
    @_initializeFormView()


  _initializeFormView: =>
    @_textareaInputView = new athena.lib.TextareaInputView
      eventhub: @eventhub

    @_textareaComponentView = new athena.lib.FormComponentView
      eventhub: @eventhub
      inputView: @_textareaInputView
      id: 'textarea'

    @formView = new athena.lib.FormView
      eventhub: @eventhub

    @formView.addComponentView @_textareaComponentView


  render: =>
    super

    @$('.modal-body').append @formView.render().el

    @


  _toolbarButtons: =>
    buttons = super

    buttons.push
      text: @options.submitButtonName
      className: 'btn-success submit'

    buttons


  values: =>
    @formView.values()


  clear: =>
    @_textareaInputView.value('')


  _submit: =>
    unless @formView.submit()
      return false

    values = @formView.values()
    @options.onSubmit?(values, @)
    @trigger 'FormModalView:Submit', values, @


  # do nothing on global enter
  _onGlobalKeyupEnter: =>
