goog.provide 'athena.lib.GridView'
goog.provide 'athena.lib.GridTileView'
goog.require 'athena.lib.View'


# renders grid of views
class athena.lib.GridView extends athena.lib.View


  tagName: 'ul'


  className: @classNameExtend 'grid-view thumbnails'


  defaults: => _.extend super,

    # options to be passed in to all constructed tiles
    tileOptions: {}


  initialize: =>
    super

    @tileViews = []

    @listenTo @collection, 'add', (model) =>
      @renderTileForModel(model) if @rendering

    @listenTo @collection, 'remove', (model) =>
      @removeTileForModel(model) if @rendering

    @listenTo @collection, 'reset', => @softRender()


  render: =>
    super
    _.each @tileViews, (tile) => tile.destroy()
    @$el.empty()
    @collection.each @renderTileForModel
    @


  renderTileForModel: (model) =>
    tile = new athena.lib.GridTileView _.extend {}, @options.tileOptions,
      eventhub: @eventhub
      model: model

    # fwd tile events
    tile.on 'all', _.bind(@trigger, @)

    @tileViews.push(tile)
    @$el.append tile.render().el
    @


  removeTileForModel: (model) =>
    tile = _.find @tileViews, (tile) => tile.model is model
    if not tile
      return

    @tileViews.pop(tile)
    tile.$el.parent().remove()
    tile.destroy()
    @



# renders a single grid tile
class athena.lib.GridTileView extends athena.lib.View


  tagName: 'li'


  className: @classNameExtend 'grid-tile-view thumbnail'


  template: _.template '''
    <a href="<%= link %>">
      <% if (icon) { %>
        <i class="<%= icon %>"></i>
      <% } %>
      <% if (thumbnail) { %>
        <img src="<%= thumbnail %>" />
      <% } %>
    </a>
    <% if (text) { %>
      <div class="text"><%= text %></div>
    <% } %>
    '''


  events: => _.extend super,
    'click a': (event) =>
      @trigger 'GridTile:Click', @
      unless @options.tileVars(@model).link
        event.preventDefault()
        return false


  defaults: => _.extend super,

    # turns a collection model into a tile model
    tileVars: (model) ->
      link: model.get?('link') or '#'
      text: model.get?('text') or ''
      icon: model.get?('icon') or ''
      thumbnail: model.get?('thumbnail') or ''


  render: =>
    super
    @$el.empty()
    tileVars = @options.tileVars @model
    _.defaults tileVars,
      {link: '#', thumbnail: '', icon: undefined, text: undefined}
    @$el.html @template tileVars
    @
