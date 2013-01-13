goog.provide 'athena.lib.TitleView'
goog.require 'athena.lib.View'

# view for generating and containing titles (icon + text)
class athena.lib.TitleView extends athena.lib.View


  tagName: 'span'


  className: @classNameExtend 'title-view ellipsis-overflow'


  template: _.template '''
    <% if (link) { %><a href="<%= link %>"><% } %>
    <% if (icon) { %><img class="icon" src="<%= icon %>"><% } %>
    <<%= tag %>><%= text %></<%= tag %>>
    <% if (link) { %></a><% } %>
    '''


  defaults: => _.extend super,
    # tagName for internal title
    titleTag: 'span'


  initialize: =>
    super

    unless @model
      throw new Error 'TitleView requires a model parameter'

    unless @model.text
      throw new Error 'TitleView.model requires a text parameter'


  render: =>
    super
    @$el.empty()
    @$el.html @template
      link: @model.link ? ''
      icon: @model.icon ? ''
      text: @model.text ? ''
      tag: @options.titleTag
    @
