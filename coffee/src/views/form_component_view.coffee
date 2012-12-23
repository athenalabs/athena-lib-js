goog.provide 'athena.lib.FormComponentView'
goog.require 'athena.lib.View'
goog.require 'athena.lib.InputView'

InputView = athena.lib.InputView

# renders a form component (help text, labels, etc) within a FormView,
# using a given InputView for the field.
class athena.lib.FormComponentView extends athena.lib.View


  className: @classNameExtend 'form-component-view control-group'


  template: _.template '''
    <label class="control-label"><%= label %></label>
    <div class="controls">
      <span class="help-inline"></span>
      <span class="help-block"></span>
    </div>
    '''


  # Note: if no InputView options
  defaults: => _.extend super,

    # InputView to take user input, If undefined, is constructed with the same
    # options object. Thus, one can specify InputView options here too.
    inputView: undefined

    # whether to skip validation checks
    noValidation: false

#    # Whether or not to save on blur (requires setter also).
#    saveOnBlur: false
#
#    # Whether or not to save on enter (requires setter also).
#    saveOnEnter: false
#
#    # Function to call to save this input.
#    setter: undefined

    # Inline help to show (when no error shows)
    helpInline: ''

    # Block help to show (when no error shows)
    helpBlock: ''

    # Label of the field
    label: ''



  initialize: =>
    super

    @inputView = @options.inputView
    @inputView ?= new InputView _.extend {}, @options,
      eventhub: @eventhub

    unless @inputView instanceof InputView
      TypeError @inputView, 'InputView'

    # override inputView.validate with our own, we call its validateErrors
    @inputView.validate = @validate


  render: =>
    super

    # render the components
    @$el.html @template label: @options.label
    @renderHelp()

    # add the inputView as the first element in .controls
    @$('.controls').prepend @inputView.render().el

    @


  # renders the help components of this view from defaults
  renderHelp: =>
    @$el.removeClass 'success'
    @$el.removeClass 'error'
    @$('.help-inline').text @options.helpInline
    @$('.help-block').text @options.helpBlock
    @


  # renders given help message on given component (e.g. 'inline' or 'block')
  # if className is given, add it the element (e.g. 'success' or 'error')
  renderHelpMessage: (message, component, className) ->
    @renderHelp()
    @$el.addClass className if className
    @$(".help-#{component}").text message
    @


  # renders the first validation error as inline help, with 'error' className
  # override to use block, other classNames, or for fancier error behavior.
  renderErrors: (errors) =>
    # simple setup: render the first error inline.
    @renderHelpMessage errors[0], 'inline', 'error'
    @


  # proxy the InputView's value
  value: (value) =>
    @inputView.value value

  # proxy the InputView's validation errors
  validationErrors: (value) =>
    @inputView.validationErrors(value)


  validate: =>
    # reset the look of the help
    @renderHelp()

    if @options.noValidation
      return true

    errors = @validationErrors @value()
    if _.isEmpty errors
      return true

    # display the first error, using the inline
    @renderErrors errors
    return false
