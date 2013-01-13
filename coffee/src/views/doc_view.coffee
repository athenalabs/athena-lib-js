goog.provide 'athena.lib.DocView'
goog.require 'athena.lib.View'

# view for rendering markdown documents
class athena.lib.DocView extends athena.lib.View


  className: @classNameExtend 'doc-view'


  defaults: => _.extend super,

    # document source
    doc: ''

    # function to render the document source
    render: (doc) -> doc


  initialize: =>
    super

    @doc @options.doc

    unless _.isFunction @options.render
      throw new Error 'render should be a function'


  render: =>
    super
    @$el.empty()
    @$el.html @options.render @doc()
    @


  doc: (doc) =>
    if doc?
      @_doc = doc
      @softRender()
    @_doc


  # render function to use with markdown sources
  @renderMarkdown: (doc) ->
    unless marked?
      throw new Error 'marked must be included'
    marked doc
