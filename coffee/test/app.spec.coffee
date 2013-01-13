goog.provide 'athena.lib.specs.App'

goog.require 'athena.lib.util'
goog.require 'athena.lib.View'
goog.require 'athena.lib.Router'

describe 'athena.lib.App', ->
  App = athena.lib.App
  derives = athena.lib.util.derives
  isOrDerives = athena.lib.util.isOrDerives

  it 'should be part of athena.lib', ->
    expect(App).toBeDefined()

  it 'should be a function', ->
    expect(typeof App).toBe 'function'

  it 'should mixin Backbone.Events', ->
    _.each Backbone.Events, (val, key) ->
      expect(App::[key]).toBeDefined()
      expect(typeof App::[key]).toBe(typeof val)

  it 'should be constructible', ->
    expect(-> new App).not.toThrow()
    expect((new App) instanceof App).toBe true

  it 'should track given options', ->
    options = {}
    app = new App options
    expect(app.options).toBe options

  it 'should be its own eventhub (no eventhub option)', ->
    eventhub = new athena.lib.View
    app = new App eventhub: eventhub
    expect(app.eventhub).toBeDefined()
    expect(app.eventhub).not.toBe eventhub
    expect(app.eventhub).toBe app


  describe 'App::initialize', ->

    it 'should be a function', ->
      expect(typeof App::initialize).toBe 'function'

    it 'should be called on construction', ->
      class TestApp extends App
        initialize: => @calledInitialize = true

      app = new TestApp
      expect(app.calledInitialize).toBe true


  describe 'App::View', ->

    it 'should be or derive from athena.lib.View', ->
      expect(isOrDerives App::View, athena.lib.View).toBe true

    it 'should be overridable', ->
      class TestView extends athena.lib.View
      class TestApp extends App
        View: TestView

      app = new TestApp
      expect(app.view instanceof TestView).toBe true


  describe 'App::view', ->

    it 'should be an instance of App::View', ->
      app = new App
      expect(app.view instanceof App::View).toBe true

    it 'should have the App as eventhub', ->
      app = new App
      expect(app.view.eventhub).toBe app


  describe 'App::Router', ->

    it 'should be or derive from athena.lib.Router', ->
      expect(isOrDerives App::Router, athena.lib.Router).toBe true

    it 'should be overridable', ->
      class TestRouter extends athena.lib.Router
      class TestApp extends App
        Router: TestRouter

      app = new TestApp
      expect(app.router instanceof TestRouter).toBe true


  describe 'App::router', ->

    it 'should be an instance of App::Router', ->
      app = new App
      expect(app.router instanceof App::Router).toBe true

    it 'should have the App as @eventhub', ->
      app = new App
      expect(app.router.eventhub).toBe app

    it 'should have the App as @app', ->
      app = new App
      expect(app.router.app).toBe app


  describe 'App::showPage', ->

    it 'should be a function', ->
      expect(typeof App::showPage).toBe 'function'

    it 'should send given page to App::view::content', ->
      app = new App
      spy = spyOn app.view, 'content'
      page = new athena.lib.View
      app.showPage page
      expect(spy).toHaveBeenCalledWith page
