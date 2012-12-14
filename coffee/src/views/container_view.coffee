goog.provide 'athena.lib.ContainerView'

goog.require 'athena.lib.View'

# contains content given to it, renders it if need be.
class athena.lib.ContainerView extends athena.lib.View

  className: @classNameExtend 'container-view'

  initialize: =>
    super()
    @content @options.content

  content: (content) =>
    if content?
      if @rendering and @_content instanceof Backbone.View
        @_content.remove()
      @_content = content
      @softRender()
    @_content

  render: =>
    super()

    @$el.empty()

    # if view, append its element.
    if @_content instanceof Backbone.View
      @_content.render()
      @$el.append @_content.el

    # if selector, append it.
    else if @_content instanceof $
      @$el.append @_content

    # if string append it
    else if _.isString @_content
      @$el.append @_content

    # if object, assume template variables.
    else if _.isObject @_content
      if !@template
        throw new Error 'ContainerView has no template to use.'

      @$el.html @template @_content

    else if @_content?
      throw new Error 'ContainerView content type unknown.'

    @
