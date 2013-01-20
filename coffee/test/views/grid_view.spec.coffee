goog.provide 'athena.lib.specs.GridView'
goog.provide 'athena.lib.specs.GridTileView'

goog.require 'athena.lib.GridView'
goog.require 'athena.lib.GridTileView'


describe 'athena.lib.GridView', ->
  test = athena.lib.util.test
  GridView = athena.lib.GridView


  newModel = (id) -> new Backbone.Model
    thumbnail: '/goo.png'
    link: '/foo'
    id: "#{id}"

  models = new Backbone.Collection
  _.each _.range(20), (i) =>
    models.add newModel i

  options =
    collection: models


  it 'should be part of athena.lib', ->
    expect(GridView).toBeDefined()

  test.describeView GridView, athena.lib.View, options

  test.describeDefaults GridView, {tileOptions: {}}, options


  describe 'GridView::renderTileForModel', ->

    it 'should add tile to GridView::tileViews', ->
      view = new GridView options
      view.render()
      expect(view.tileViews.length).toBe 20
      models.add newModel '21'
      tile = view.tileViews[20]
      expect(tile.model.id).toBe '21'

      expect(view.tileViews.length).toBe 21
      expect(_.contains view.tileViews, tile).toBe true
      models.remove '21'

    it 'should add tile elem to view elem', ->
      view = new GridView options
      view.render()
      models.add newModel '21'
      tile = view.tileViews[20]
      expect(tile.el.parentNode).toBe view.el
      models.remove '21'


  describe 'GridView::removeTileForModel', ->

    it 'should remove tile from GridView::tileViews', ->
      view = new GridView options
      view.render()
      models.add newModel '21'
      tile = view.tileViews[20]

      expect(view.tileViews.length).toBe 21
      expect(_.contains view.tileViews, tile).toBe true

      models.remove '21'
      expect(view.tileViews.length).toBe 20
      expect(_.contains view.tileViews, tile).toBe false

    it 'should remove tile elem from view elem', ->
      view = new GridView options
      view.render()
      models.add newModel '21'
      tile = view.tileViews[20]

      models.remove '21'
      expect(tile.el.parentNode).toBe null


  describe 'collection changes', ->

    it 'should call renderTileForModel on add', ->
      view = new GridView options
      view.render()

      spy = spyOn view, 'renderTileForModel'
      models.add newModel '21'
      expect(spy).toHaveBeenCalled()

      models.remove '21'

    it 'should call removeTileForModel on remove', ->
      view = new GridView options
      view.render()
      models.add newModel '21'

      spy = spyOn view, 'removeTileForModel'
      models.remove '21'
      expect(spy).toHaveBeenCalled()

    it 'should softRender on reset', ->
      view = new GridView options
      view.render()
      spy = spyOn view, 'softRender'
      models.reset models.models
      expect(spy).toHaveBeenCalled()


  it 'should fwd GridTileView events', ->
    view = new GridView options
    spy = new test.EventSpy view, 'all'
    view.render()
    tile = view.tileViews[0]
    expect(spy.triggerCount).toBe 0
    tile.trigger 'foo'
    expect(spy.triggerCount).toBe 1
    tile.trigger 'bar'
    expect(spy.triggerCount).toBe 2


  it 'should look good', ->
    # create a div to safely append content to the page
    $safe = $('<div>').addClass('athena-lib-test').appendTo('body')

    # add a AcornOptionsView into the DOM to see how it looks.
    view = new GridView options
    view.render()
    $safe.append view.el



describe 'athena.lib.GridTileView', ->
  test = athena.lib.util.test
  GridTileView = athena.lib.GridTileView

  options =
    model: new Backbone.Model
      link: '/foo'
      thumbnail: 'bar.png'


  it 'should be part of acorn.web', ->
    expect(GridTileView).toBeDefined()

  test.describeView GridTileView, athena.lib.View, options


  it 'should trigger `GridTile:Click` on click', ->
    view = new GridTileView options
    view.render()
    spy = new test.EventSpy view, 'GridTile:Click'
    view.$('a').trigger 'click'
    expect(spy.triggerCount).toBe 1

  it 'should pass itself on `GridTile:Click`', ->
    view = new GridTileView options
    view.render()
    spy = new test.EventSpy view, 'GridTile:Click'
    view.$('a').trigger 'click'
    expect(spy.arguments[0]).toEqual [view]


  it 'should look good', ->
    # create a div to safely append content to the page
    $safe = $('<div>').addClass('athena-lib-test').appendTo('body')

    # add a AcornOptionsView into the DOM to see how it looks.
    view = new GridTileView options
    view.render()
    $safe.append view.el