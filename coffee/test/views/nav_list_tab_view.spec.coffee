goog.provide 'athena.lib.specs.NavListTabView'

goog.require 'athena.lib.util'
goog.require 'athena.lib.NavListTabView'

describe 'athena.lib.NavListTabView', ->
  View = athena.lib.View
  NavListView = athena.lib.NavListView
  NavListTabView = athena.lib.NavListTabView
  ContainerView = athena.lib.ContainerView
  test = athena.lib.util.test

  it 'should be part of athena.lib', ->
    expect(NavListTabView).toBeDefined()

  test.describeView NavListTabView, athena.lib.View, ->

    it 'should look good', ->
      # create a div to safely append content to the page
      $safe = $('<div>').addClass('athena-lib-test').appendTo('body')

      items = [
        {className: 'nav-header', text: 'Header'},
        {id: 'foo', link:'/foo', text: 'Foo', leftIcon: 'icon-play'},
        {id: 'bar', link:'/bar', text: 'Bar', leftIcon: 'icon-pause'},
        {id: 'bar', link:'/bar', text: 'Baz', rightIcon: 'icon-trash'},
      ]

      views =
        foo: new ContainerView {content: 'foo'}
        bar: new ContainerView {content: 'bar'}

      view = new NavListTabView
        items: items
        views: views

      view.render()
      $safe.append view.$el


  test.describeDefaults NavListTabView,
    selected: undefined
    items: []
    views: {}


  test.describeSubview
    View: NavListTabView
    subviewAttr: 'navListView'
    Subview: NavListView
    checkDOM: (child, parent) -> child.parentNode.parentNode is parent


  describe 'NavListTabView::views', ->

    it 'should be initialized with @options.views', ->
      views = {foo: new View, bar: new View}
      view = new NavListTabView views: views
      expect(view.views).toEqual views

    it 'should be a clone, not @options.items', ->
      views = {foo: new View, bar: new View}
      view = new NavListTabView views: views
      expect(view.views).toEqual views
      expect(view.views).not.toBe views


  describe 'NavListTabView::renderView', ->

    it 'should be called on render with @selected', ->
      views = {foo: new View, bar: new View}
      view = new NavListTabView views: views, selected: 'foo'
      spy = spyOn view, 'renderView'
      view.render()
      expect(spy).toHaveBeenCalledWith 'foo'

    it 'should not error if view does not exist', ->
      view = new NavListTabView
      expect(-> view.renderView 'foo').not.toThrow()

    it 'should render selected view', ->
      views = {foo: new View, bar: new View}
      view = new NavListTabView views: views
      spy = spyOn(views.foo, 'render').andCallThrough()
      view.renderView 'foo'
      expect(spy).toHaveBeenCalled()

    it 'should append selected view elem', ->
      views = {foo: new View, bar: new View}
      view = new NavListTabView views: views
      view.render()
      view.renderView 'foo'
      expect(views.foo.el.parentNode.parentNode).toBe view.el


  describe 'NavListTabView::select', ->

    it 'should be triggered by `NavList:Select`', ->
      view = new NavListTabView items: [{id: 'foo'}]
      spy = spyOn view, 'select'
      view.navListView.selectItem 'foo'
      expect(spy).toHaveBeenCalledWith 'foo'

    it 'should trigger `NavListTab:Select`', ->
      view = new NavListTabView items: [{id: 'foo'}]
      spy = new test.EventSpy view, 'NavListTab:Select'
      view.select 'foo'
      expect(spy.triggered).toBe true

    it 'should set @selected', ->
      view = new NavListTabView
      view.select 'foo'
      expect(view.selected).toBe 'foo'
      view.select 'bar'
      expect(view.selected).toBe 'bar'

    it 'should call renderView if rendering', ->
      view = new NavListTabView
        items: [{id: 'foo'}]
        views: {foo: new View}

      view.render()
      spy = spyOn view, 'renderView'
      view.select 'foo'
      expect(spy).toHaveBeenCalledWith 'foo'

    it 'should not call renderView if not rendering', ->
      view = new NavListTabView
        items: [{id: 'foo'}]
        views: {foo: new View}

      spy = spyOn view, 'renderView'
      view.select 'foo'
      expect(spy).not.toHaveBeenCalled()

    it 'should remove old view', ->
      view = new NavListTabView
        items: [{id: 'foo'}, {id: 'bar'}]
        views: {foo: new View, bar: new View}

      spy = spyOn view.views.foo, 'remove'
      view.select 'foo'
      expect(spy).not.toHaveBeenCalled()
      view.select 'bar'
      expect(spy).toHaveBeenCalled()
