goog.provide 'athena.lib.DirectiveView'
goog.require 'athena.lib.View'

# view for generating and containing directives (title paths)
class athena.lib.DirectiveView extends athena.lib.View


  tagName: 'span'


  className: @classNameExtend 'directive-view ellipsis-overflow'


  defaults: => _.extend super,
    # rendered to separate directive parts
    separator: ' / '

    # parts to render (to begin with)
    parts: []


  initialize: =>
    super

    # clone to avoid changing given array
    @parts = _.clone @options.parts


  render: =>
    super
    @$el.empty()
    _.each @parts, @renderPart
    @


  renderSeparator: =>
    @$el.append $('<span>').append @options.separator
    @


  renderPart: (part) =>

    # if view, append its element.
    if part instanceof Backbone.View
      @$el.append part.render().el

    # else append it directly
    else
      @$el.append part

    unless part is _.last @parts
      @renderSeparator()

    @


  addPart: (part) =>
    @parts.push part

    # if we're rendering, update
    if @rendering

      # separator first, as we're adding to the end
      unless part is _.first @parts
        @renderSeparator()

      @renderPart part
    @
