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

    masonry: false          # pass true to turn on masonry
    columnWidth: undefined  # defaults to size of first element
    gutterWidth: 10         # space between columns


  initialize: =>
    super

    @tileViews = []

    @listenTo @collection, 'add', (model) =>
      @renderTileForModel(model) if @rendering

    @listenTo @collection, 'remove', (model) =>
      @removeTileForModel(model) if @rendering

    @listenTo @collection, 'reset', => @softRender()

    @listenTo @collection, 'all', => @refreshMasonry()


  render: =>
    super
    _.each @tileViews, (tile) => tile.destroy()
    @$el.empty()
    @collection.each @renderTileForModel

    # Try masonizing after call stack clears
    setTimeout @refreshMasonry, 0

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


  refreshMasonry: =>
    unless @options.masonry
      return

    unless util.elementInDom @el
      console.log 'WARNING: attempt to masonize mediaListView when not in DOM'
      return

    container = @$el
    itemSelector = 'li.grid-tile-view.thumbnail'

    # if previously masonized, reload masonry when call stack clears
    if @_masonized
      setTimeout (=> container.masonry 'reload'), 0

    # else initialize masonry
    else
      @_masonized = true
      container.masonry
        itemSelector: itemSelector
        columnWidth: @options.columnWidth
        gutterWidth: @options.gutterWidth

    # reload masonry on images loaded
    container.imagesLoaded => container.masonry 'reload'



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
      link = @options.tileVars(@model).link
      unless link and link isnt '#'
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

    tooltip = @model.get 'tooltip'
    if tooltip
      @$el.tooltip(tooltip)

    @
