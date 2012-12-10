goog.provide 'athena.lib.ContainerView'

goog.require 'athena.lib.View'

# contains content given to it, renders it if need be.
class athena.lib.ContainerView extends athena.lib.View

  initialize: =>
    super()
    @content = @options.content;


  render: =>
    super()

    @$el.empty()

    # if view, append its element.
    if @content instanceof Backbone.View
      @content.render()
      @$el.append @content.el

    # if selector, append it.
    else if @content instanceof $
      @$el.append @content

    # if string append it
    else if _.isString @content
      @$el.append @content

    # if object, assume template variables.
    else if _.isObject @content
      if !@template
        throw new Error 'ContainerView has no template to use.'

      @$el.html @template @content

    else if @content?
      throw new Error 'ContainerView content type unknown.'

    @
