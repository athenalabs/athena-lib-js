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


  initialize: =>
    super

    @model ?= new Backbone.Model
    unless @model instanceof Backbone.Model
      throw new Error 'InputView requires `model` of type Backbone.Model'

  elAttributes: =>
    placeholder: @options.placeholder
    type: @options.type
    value: @value()


  # sets and/or gets the input value
  value: (value) =>
    if value?
      @model.set 'value', value
      @softRender()
    @model.get 'value', value


  # returns validation errors
  validationErrors: (value) => []


  # returns whether or not value is valid
  validate: =>
    _.isEmpty @validationErrors()
