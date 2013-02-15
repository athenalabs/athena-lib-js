goog.provide 'athena.lib.InputView'
goog.require 'athena.lib.View'

# base class for fields of different types
class athena.lib.InputView extends athena.lib.View


  className: @classNameExtend 'input-view'


  tagName: 'input'


  defaults: => _.extend super,

    # the type for the html input
    type: 'text'

    # the placeholder for the html input
    placeholder: ''

    # whether to validate on blur
    validateOnBlur: true

    # whether to blur on enter
    blurOnEnter: true

    # Whether or not to save on blur (requires setter also).
    saveOnBlur: false

    # Function to call to save this input.
    save: undefined



  events: => _.extend super,
    'blur': @onBlur
    'keyup': @onKeyup


  initialize: =>
    super
    @value @options.value


  elAttributes: =>
    placeholder: @options.placeholder
    type: @options.type
    value: @value()


  # sets and/or gets the input value - override to store elsewhere
  value: (value) =>
    if value?
      @$el.val value
    @$el.val()


  # returns validation errors
  validationErrors: (value) => []


  # returns whether or not value is valid
  validate: =>
    _.isEmpty @validationErrors @value()

  # events
  onBlur: (event) =>
    unless @options.validateOnBlur or @options.saveOnBlur
      return

    if @validate() and @options.saveOnBlur
      @options.save @value()

  onKeyup: (event) =>
    if event.keyCode is util.keys.ENTER
      @onEnter(event)

  onEnter: (event) =>
    if @options.blurOnEnter
      @$el.trigger 'blur'
