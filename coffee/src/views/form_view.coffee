goog.provide 'athena.lib.FormView'
goog.require 'athena.lib.View'
goog.require 'athena.lib.FormComponentView'

FormComponentView = athena.lib.FormComponentView

# renders a form with subcomponents.
class athena.lib.FormView extends athena.lib.View


  tagName: 'form'


  className: @classNameExtend 'form-view'


  defaults: => _.extend super,
    # whether to skip validation checks
    noValidation: false


  elAttributes: => _.extend super,
    # disables automatic form submission on enter
    onsubmit: 'return false;'


  initialize: =>
    super
    @componentViews = []


  render: =>
    super
    @$el.empty()
    _.each @componentViews, @renderComponentView
    @


  renderComponentView: (view) =>
    unless view instanceof FormComponentView
      throw new Error 'view must be of type FormComponentView'

    @$el.append view.render().el
    @


  addComponentView: (view) =>
    unless view instanceof FormComponentView
      throw new Error 'view must be of type FormComponentView'

    @componentViews.push view
    if @rendering
      @renderComponentView view
    @


  # retrieve a component view through its id
  getComponentView: (id) =>
    _.find @componentViews, (view) -> view.id == id


  # returns the values of all form components in an object
  values: =>
    _.object _.map @componentViews, (view) ->
      [view.id, view.value()]


  validate: =>
    if @options.noValidation
      return true

    _.all @componentViews, (view) -> view.validate()


  submit: =>
    unless @validate()
      @trigger 'FormView:Submit:Error', 'Validation failed.'
      return false

    @trigger 'FormView:Submit:Success'
    true
