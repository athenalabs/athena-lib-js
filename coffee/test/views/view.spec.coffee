goog.provide 'athena.lib.specs.View'

goog.require 'athena.lib.util'
goog.require 'athena.lib.View'

describe 'View', ->
  View = athena.lib.View
  lib = athena.lib
  util = athena.lib.util

  it 'should be part of athena.lib', ->
    expect(View).toBeDefined()

  it 'should derive from Backbone.View', ->
    expect(util.derives View, Backbone.View).toBe true

  test.describeView View, Backbone.View

  it 'should have an eventhub option, with the Events interface', ->
    expect(_.has View.prototype.defaults(), 'eventhub').toBe true
    view = new View()
    expect(view.eventhub).toBeDefined()
    expect(_.isFunction view.eventhub.on).toBe true
    expect(_.isFunction view.eventhub.off).toBe true
    expect(_.isFunction view.eventhub.trigger).toBe true
    view2 = new View eventhub: view
    expect(view2.eventhub).toBe view

  it 'should support option `extraClasses`', ->
    expect(View.prototype.defaults().extraClasses).toBeDefined()
    expect(_.isArray View.prototype.defaults().extraClasses).toBe true
    view = new View extraClasses: ['class1', 'class2']
    expect(view.$el.hasClass 'class1').toBe true
    expect(view.$el.hasClass 'class2').toBe true
    expect(view.$el.hasClass 'class3').toBe false

  it 'should track rendering', ->
    view = new View()
    expect(view.rendering).toBe false
    view.render()
    expect(view.rendering).toBe true

  it 'should support softRender', ->
    view1 = new View()
    view2 = new View()

    # spy on callbacks
    renderSpy1 = spyOn(view1, 'render').andCallThrough()
    renderSpy2 = spyOn(view2, 'render').andCallThrough()

    # ensure rendering is false
    expect(view1.rendering).toBe false
    expect(view2.rendering).toBe false

    # try soft rendering, should not call render.
    view1.softRender()
    view2.softRender()
    expect(renderSpy1.callCount).toBe 0
    expect(renderSpy2.callCount).toBe 0


    # call render, and check state changes
    view1.render()
    expect(view1.rendering).toBe true
    expect(view2.rendering).toBe false
    expect(renderSpy1.callCount).toBe 1
    expect(renderSpy2.callCount).toBe 0


    # call softRender, check 1 rendered and 2 did not.
    view1.softRender()
    view2.softRender()
    expect(view1.rendering).toBe true
    expect(view2.rendering).toBe false
    expect(renderSpy1.callCount).toBe 2
    expect(renderSpy2.callCount).toBe 0

    # change rendering state, softRender, check 2 rendered and 1 did not.
    view1.rendering = false
    view2.rendering = true
    view1.softRender()
    view2.softRender()
    expect(view1.rendering).toBe false
    expect(view2.rendering).toBe true
    expect(renderSpy1.callCount).toBe 2
    expect(renderSpy2.callCount).toBe 1

    # call destroy, check state,
    view1.destroy()
    view2.destroy()
    expect(view1.rendering).toBe false
    expect(view2.rendering).toBe false

    # softRender should not call either.
    view1.softRender()
    view2.softRender()
    expect(renderSpy1.callCount).toBe 2
    expect(renderSpy2.callCount).toBe 1

  it 'should have static method classNameExtend, which extends classNames', ->
    class Firetruck extends View
      className: @classNameExtend 'firetruck'
    class RedFiretruck extends Firetruck
      className: @classNameExtend 'red'
    class BigRedFiretruck extends RedFiretruck
      className: @classNameExtend 'big'

    view = new View()
    firetruck = new Firetruck()
    redFiretruck = new RedFiretruck()
    bigRedFiretruck = new BigRedFiretruck()

    expect(view.className).toBe ''
    expect(firetruck.className).toBe 'firetruck'
    expect(redFiretruck.className).toBe 'firetruck red'
    expect(bigRedFiretruck.className).toBe 'firetruck red big'


  describe 'View::elAttributes', ->

    it 'should be a function', ->
      expect(typeof View::elAttributes).toBe 'function'

    it 'should return an object', ->
      expect(typeof new View().elAttributes()).toBe 'object'

    it 'should set these on the element on render', ->
      class TestView extends View
        elAttributes: => {foo: 'bar', biz: 'baz'}
      view = new TestView
      view.render()
      expect(view.$el.attr 'foo').toEqual 'bar'
      expect(view.$el.attr 'biz').toEqual 'baz'
