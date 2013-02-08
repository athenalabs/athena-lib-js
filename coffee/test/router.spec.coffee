goog.provide 'athena.lib.specs.Router'

goog.require 'athena.lib.util'
goog.require 'athena.lib.View'
goog.require 'athena.lib.Router'

describe 'athena.lib.Router', ->
  Router = athena.lib.Router
  derives = athena.lib.util.derives

  options = eventhub: new Backbone.View

  it 'should be part of athena.lib', ->
    expect(Router).toBeDefined()

  it 'should be a function', ->
    expect(typeof Router).toBe 'function'

  it "should derive from Backbone.Router", ->
    expect(derives Router, Backbone.Router).toBe true

  it 'should be constructible with given options', ->
    expect(-> new Router options).not.toThrow()
    router = new Router options
    expect(router instanceof Router).toBe true
    expect(router.options).toBe options

  it 'should have an eventhub option, with the Events interface', ->
    router = new Router()
    expect(router.eventhub).toBeDefined()
    expect(router.eventhub).toBe router
    expect(_.isFunction router.eventhub.on).toBe true
    expect(_.isFunction router.eventhub.off).toBe true
    expect(_.isFunction router.eventhub.trigger).toBe true
    router2 = new Router eventhub: router
    expect(router2.eventhub).toBe router

  it 'should have an app option', ->
    router = new Router()
    expect(router.app).not.toBeDefined()
    router2 = new Router app: router
    expect(router2.app).toBe router

  describe 'Router::navigateBrowser', ->

    it 'should be a function', ->
      expect(typeof Router::go).toBe 'function'

    # unfortunately, we cannot test this function beyond this, as we cannot
    # mock the `window.location` object.

  describe 'Router::go', ->

    it 'should be a function', ->
      expect(typeof Router::go).toBe 'function'

    it 'should throw without a parameter', ->
      router = new Router()
      expect(-> router.go()).toThrow()
      expect(-> router.go '/foo').not.toThrow()

    it 'should trigger Router::navigate for relative urls', ->
      urls = ['/foo', '/foo/bar?is=fun', '#fragment']
      for relative_url in urls
        router = new Router()
        spy1 = spyOn(router, 'navigate')
        spy2 = spyOn(router, 'navigateBrowser')

        router.go relative_url
        expect(spy1).toHaveBeenCalled()
        expect(spy1).toHaveBeenCalledWith relative_url, trigger: true
        expect(spy2).not.toHaveBeenCalled()

    it 'should trigger Router::navigateBrowser for absolute urls', ->
      urls = ['http://domain.com/foo', '//absolute.path', 'https://securish']
      for absolute_url in urls
        router = new Router()
        spy1 = spyOn(router, 'navigate')
        spy2 = spyOn(router, 'navigateBrowser')

        router.go absolute_url
        expect(spy1).not.toHaveBeenCalled()
        expect(spy2).toHaveBeenCalled()
        expect(spy2).toHaveBeenCalledWith absolute_url


  describe 'Router::events: Go', ->

    it 'should call `Router::go` on @eventhub `Go`', ->
      eventhub = new athena.lib.View
      router = new Router eventhub: eventhub
      spy = spyOn(router, 'go')
      eventhub.trigger 'Go', '/foo'
      expect(spy).toHaveBeenCalled()

    it 'should call `Router::go` with a given url', ->
      eventhub = new athena.lib.View
      router = new Router eventhub: eventhub
      spy = spyOn(router, 'go')
      eventhub.trigger 'Go', '/foo'
      expect(spy).toHaveBeenCalledWith '/foo'


  describe 'Router::routeInternalLinks', ->

    it 'should intercept and call navigate on links clicked', ->
      router = new Router
      link = $('<a>').attr('href', '/foo').appendTo $('body')
      spy = spyOn(router, 'navigate')
      router.routeInternalLinks()
      link.trigger('click')
      expect(spy).toHaveBeenCalled()

    it 'should not intercept links clicked with SHIFT', ->
      router = new Router
      link = $('<a>').attr('href', '/foo').appendTo $('body')
      spy = spyOn(router, 'navigate')
      router.routeInternalLinks()
      link.trigger $.Event 'click', shiftKey: true
      expect(spy).not.toHaveBeenCalled()

    it 'should not intercept links clicked with CTRL', ->
      router = new Router
      link = $('<a>').attr('href', '/foo').appendTo $('body')
      spy = spyOn(router, 'navigate')
      router.routeInternalLinks()
      link.trigger $.Event 'click', ctrlKey: true
      expect(spy).not.toHaveBeenCalled()

    it 'should not intercept links clicked with ALT', ->
      router = new Router
      link = $('<a>').attr('href', '/foo').appendTo $('body')
      spy = spyOn(router, 'navigate')
      router.routeInternalLinks()
      link.trigger $.Event 'click', altKey: true
      expect(spy).not.toHaveBeenCalled()

    it 'should not intercept links clicked with META', ->
      router = new Router
      link = $('<a>').attr('href', '/foo').appendTo $('body')
      spy = spyOn(router, 'navigate')
      router.routeInternalLinks()
      link.trigger $.Event 'click', metaKey: true
      expect(spy).not.toHaveBeenCalled()
