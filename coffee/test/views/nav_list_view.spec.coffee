goog.provide 'athena.lib.specs.NavListView'

goog.require 'athena.lib.util'
goog.require 'athena.lib.NavListView'

describe 'athena.lib.NavListView', ->
  NavListView = athena.lib.NavListView
  test = athena.lib.util.test

  it 'should be part of athena.lib', ->
    expect(NavListView).toBeDefined()

  test.describeView NavListView, athena.lib.View, ->

    it 'should look good', ->
      # create a div to safely append content to the page
      $safe = $('<div>').addClass('athena-lib-test').appendTo('body')

      items = [
        {className: 'nav-header', text: 'Header'},
        {id: 'foo', link:'/foo', text: 'Foo', leftIcon: 'icon-play'},
        {id: 'bar', link:'/bar', text: 'Bar', leftIcon: 'icon-pause'},
        {id: 'bar', link:'/bar', text: 'Baz', rightIcon: 'icon-trash'},
      ]

      view = new NavListView items: items
      view.render()
      $safe.append view.$el


  test.describeDefaults NavListView,
    followLinks: false
    items: []


  describe 'NavListView::items', ->

    it 'should be initialized with @options.items', ->
      items = [{text: 'Foo'}, {text: 'Bar'}]
      view = new NavListView items: items
      expect(view.items).toEqual items

    it 'should be a clone, not @options.items', ->
      items = [{text: 'Foo'}, {text: 'Bar'}]
      view = new NavListView items: items
      expect(view.items).toEqual items
      expect(view.items).not.toBe items

  describe 'NavListView::renderItem', ->

    it 'should be called per item', ->
      items = [{text: 'Foo'}, {text: 'Bar'}]
      view = new NavListView items: items
      spy = spyOn view, 'renderItem'
      view.render()
      expect(spy.callCount).toBe 2
      expect(spy).toHaveBeenCalledWith(items[0])
      expect(spy).toHaveBeenCalledWith(items[1])

    it 'should return a <li> selector', ->
      view = new NavListView
      item = view.renderItem {text:'Foo'}
      expect(item instanceof $).toBe true
      expect(item[0].tagName.toLowerCase()).toBe 'li'

    it 'should add className', ->
      view = new NavListView
      item = view.renderItem {text:'Foo', className: 'bar'}
      expect(item.hasClass 'bar').toBe true

    it 'should set id as data-nav attr', ->
      view = new NavListView
      item = view.renderItem {text:'Foo', id: 'bar'}
      expect(item.attr 'data-nav').toBe 'bar'

    it 'should add text to a span', ->
      view = new NavListView
      item = view.renderItem {text:'Foo', className: 'bar'}
      expect(item.find('span').text()).toBe 'Foo'

    it 'should add a left icon', ->
      view = new NavListView
      item = view.renderItem {text:'Foo', leftIcon: 'icon-trash'}
      expect(item.find('i:first-child').hasClass 'icon-trash').toBe true

    it 'should add a right icon', ->
      view = new NavListView
      item = view.renderItem {text:'Foo', rightIcon: 'icon-trash'}
      expect(item.find('i:last-child').hasClass 'icon-trash').toBe true

    it 'should add a link', ->
      view = new NavListView
      item = view.renderItem {text:'Foo', link: 'bar'}
      expect(item.find('a').attr 'href').toBe 'bar'


  describe 'NavListView::$item', ->

    it 'should select item with given id', ->
      items = [{id:'foo', text: 'Foo'}, {id:'bar', text: 'Bar'}]
      view = new NavListView items: items
      view.render()
      item = view.$item('foo')
      expect(item instanceof $).toBe true
      expect(item.length).toBe 1
      expect(item[0].tagName.toLowerCase()).toBe 'li'
      expect(item.find('span').text()).toBe 'Foo'

    it 'should select multiple items with given id', ->
      items = [{id:'foo', text: 'Foo'}, {id:'foo', text: 'Bar'}]
      view = new NavListView items: items
      view.render()
      item = view.$item('foo')
      expect(item instanceof $).toBe true
      expect(item.length).toBe 2
      expect(item[0].tagName.toLowerCase()).toBe 'li'
      expect(item.find('span').text()).toBe 'FooBar'


  describe 'NavListView::highlightItem', ->

    it 'should add class active from highlighted id', ->
      items = [{id:'foo', text: 'Foo'}, {id:'bar', text: 'Bar'}]
      view = new NavListView items: items
      view.render()
      expect(view.$item('foo').hasClass 'active').toBe false
      expect(view.$item('bar').hasClass 'active').toBe false

      view.highlightItem 'foo'
      expect(view.$item('foo').hasClass 'active').toBe true

      view.highlightItem 'bar'
      expect(view.$item('bar').hasClass 'active').toBe true

    it 'should remove class active from non-highlighted ids', ->
      items = [{id:'foo', text: 'Foo'}, {id:'bar', text: 'Bar'}]
      view = new NavListView items: items

      view.render()
      view.highlightItem 'foo'
      expect(view.$item('foo').hasClass 'active').toBe true
      expect(view.$item('bar').hasClass 'active').toBe false

      view.highlightItem 'bar'
      expect(view.$item('foo').hasClass 'active').toBe false
      expect(view.$item('bar').hasClass 'active').toBe true

      view.highlightItem 'baz'
      expect(view.$item('foo').hasClass 'active').toBe false
      expect(view.$item('bar').hasClass 'active').toBe false


  describe 'NavListView::selectItem', ->

    it 'should trigger `NavList:Select`', ->
      view = new NavListView items: [{id: 'foo', text: 'Foo'}]
      spy = new test.EventSpy view, 'NavList:Select'
      view.selectItem 'foo'
      expect(spy.triggered).toBe true

    it 'should send id via `NavList:Select`', ->
      view = new NavListView items: [{id: 'foo', text: 'Foo'}]
      spy = new test.EventSpy view, 'NavList:Select'
      view.selectItem 'foo'
      expect(spy.arguments[0]).toEqual [view, 'foo']

    it 'should throw error if item not found', ->
      view = new NavListView items: [{id: 'foo', text: 'Foo'}]
      spy = new test.EventSpy view, 'NavList:Select'
      expect(-> view.selectItem 'bar').toThrow()
