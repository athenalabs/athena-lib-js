goog.provide 'athena.lib.GridView'
goog.provide 'athena.lib.GridTileView'
goog.require 'athena.lib.View'


# renders grid of views
class athena.lib.GridView extends athena.lib.View


  tagName: 'ul'


  className: @classNameExtend 'grid-view thumbnails'


  defaults: => _.extend super,

    # turns a collection model into a tile model
    tileModel: (model) -> model


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
    tile = new athena.lib.GridTileView
      eventhub: @eventhub
      model: model

    @tileViews.push(tile)
    li = $('<li class="span3">').append tile.render().el
    @$el.append li
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
      <img src="<%= thumbnail %>" />
    </a>
    '''


  render: =>
    super
    @$el.empty()
    @$el.html @template
      link: @model.get?('link') or '#'
      thumbnail: @model.get?('thumbnail') or ''
    @
