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



  events: => _.extend super,
    'blur': =>
      if @options.validateOnBlur
        @validate()

    'keyup': (event) =>
      if @options.blurOnEnter and event.keyCode is util.keys.ENTER
        @$el.trigger 'blur'


  initialize: =>
    super
    @value @options.value


  elAttributes: =>
    placeholder: @options.placeholder
    type: @options.type
    value: @value()


  # sets and/or gets the input value
  value: (value) =>
    if value?
      @$el.val value
    @$el.val()


  # returns validation errors
  validationErrors: (value) => []


  # returns whether or not value is valid
  validate: =>
    _.isEmpty @validationErrors @value()
