goog.provide 'athena.lib.util.specs.test'

goog.require 'athena.lib.util.test'
goog.require 'athena.lib.FormView'

describe 'athena.lib.util.test', ->
  test = athena.lib.util.test

  it 'should be part of athena.lib.util', ->
    expect(test).toBeDefined()

  it 'should be an object', ->
    expect(_.isObject util).toBe true


  describe 'test.throwsExceptionWithString', ->
    throwyFn = (param) -> throw Error('Hai! 42')
    fn = (param) ->

    it 'throws an exception when it should', ->
      expect(test.throwsExceptionWithString '42', throwyFn).toBe true
      expect(test.throwsExceptionWithString '42', throwyFn, []).toBe true
      expect(test.throwsExceptionWithString '42', throwyFn, [ 'ey' ]).toBe true

    it 'doesn\'t throw an exception when it shouldn\'t', ->
      expect(test.throwsExceptionWithString '45', throwyFn).toBe false
      expect(test.throwsExceptionWithString '45', throwyFn, []).toBe false
      expect(test.throwsExceptionWithString '45', throwyFn, [ 'ey' ]).toBe false

      expect(test.throwsExceptionWithString '42', fn).toBe false
      expect(test.throwsExceptionWithString '42', fn, []).toBe false
      expect(test.throwsExceptionWithString '42', fn, [ 'ey' ]).toBe false


  describe 'test.describeProperty', ->
    toSeekTheGrail = 'To seek the Holy Grail'
    class Knight extends athena.lib.Model
      name: @property 'name'
      title: @property('title', setter: false)
      color: @property('color', default: 'blue')
      quest: @property('quest', {default: toSeekTheGrail, setter: false})

    @callback = ->
      it 'should run this test within the block', ->
        expect(true).toBe true

    spy = spyOn(@, 'callback').andCallThrough()

    test.describeProperty Knight, 'name', {}, {}, @callback
    test.describeProperty Knight, 'title', {title: 'Sir'}, setter: false
    test.describeProperty Knight, 'color', {}, default: 'blue'
    test.describeProperty Knight, 'quest', {},
      default: toSeekTheGrail
      setter: false

    it 'should call the callback', ->
      expect(spy).toHaveBeenCalled()


  describe 'test.describeView', ->
    class View extends athena.lib.View
      initialize: =>
        super
        View.calledWithOptions = @options

    options = {a:1, b:2}
    @callback = ->
      it 'should run this test within the block', ->
        expect(true).toBe true

    spy = spyOn(@, 'callback').andCallThrough()

    test.describeView View, athena.lib.View, options, @callback

    it 'should call the View initialize with given options', ->
      expect(View.calledWithOptions).toBe options

    it 'should call the callback', ->
      expect(spy).toHaveBeenCalled()


    class BadView extends athena.lib.View
      initialize: =>
        throw new Error 'options are bogus'
      defaults: {}
      events: => 5
      render: =>
        super
        undefined

    # uncomment below to ensure the tests fail :)
    # test.describeView BadView, View


  describe 'test.describeSubview', ->
    class ChildView extends athena.lib.View

    class ParentView extends athena.lib.View
      initialize: =>
        super
        ParentView.calledWithOptions = @options
        @namedSubview = new ChildView eventhub: @eventhub

      render: =>
        super
        @$el.append @namedSubview.render().el
        @

    class GrandParentView extends athena.lib.View
      initialize: =>
        super
        options = _.extend {}, @options, eventhub: @eventhub
        @childSubview = new ParentView options
        @grandchildSubview = @childSubview.namedSubview

      render: =>
        super
        @$el.append @childSubview.render().el
        @


    # test with the GrandParentView
    options =
      View: ParentView
      viewOptions: {a: 1, b:2}
      subviewAttr: 'namedSubview'
      Subview: ChildView
      callback: ->
        it 'should run this test within the block', ->
          expect(true).toBe true

    spy = spyOn(options, 'callback').andCallThrough()

    test.describeSubview options, options.callback

    it 'should call the ParentView initialize with given options', ->
      expect(ParentView.calledWithOptions).toBe options.viewOptions

    it 'should call the callback', ->
      expect(spy).toHaveBeenCalled()

    # test with the GrandParentView
    test.describeSubview
      View: GrandParentView
      subviewAttr: 'grandchildSubview'
      Subview: ChildView
      checkDOM: (subEl, el) -> subEl.parentNode.parentNode is el



  describe 'test.describeFormComponent', ->

    options =
      id: 'foo'
      type: 'text'
      label: 'Foo'
      placeholder: 'enter foo'
      helpBlock: 'The Foo to end all Foos'
      helpInline: 'Some Foo, that is.'


    class FooFormView extends athena.lib.FormView

      initialize: =>
        super
        @foo = new athena.lib.FormComponentView _.extend {}, options,
          eventhub: @eventhub
        @addComponentView @foo


    test.describeFormComponent _.extend {}, options,
      View: FooFormView
      name: 'foo'



  describe 'EventSpy', ->
    it 'should be a function', ->
      expect(_.isFunction test.EventSpy).toBe true

    it 'should listen to Backbone event triggers', ->
      m = new Backbone.Model
      s = new test.EventSpy m, 'event'
      expect(s.triggered).toBe false
      m.trigger 'event'
      expect(s.triggered).toBe true

    it 'should not listen to Backbone events not specified', ->
      m = new Backbone.Model
      s = new test.EventSpy m, 'event'
      expect(s.triggered).toBe false
      m.trigger 'otherevent'
      expect(s.triggered).toBe false
      m.trigger 'event'
      expect(s.triggered).toBe true

    it 'should count how many times an event is triggered', ->
      m = new Backbone.Model
      s = new test.EventSpy m, 'event'
      expect(s.triggerCount).toBe 0
      m.trigger 'event'
      expect(s.triggerCount).toBe 1
      m.trigger 'event'
      expect(s.triggerCount).toBe 2
      m.trigger 'event'
      expect(s.triggerCount).toBe 3

    it 'should not count events not specified', ->
      m = new Backbone.Model
      s = new test.EventSpy m, 'event'
      expect(s.triggerCount).toBe 0
      m.trigger 'event'
      expect(s.triggerCount).toBe 1
      m.trigger 'otherevent'
      expect(s.triggerCount).toBe 1
      m.trigger 'event'
      expect(s.triggerCount).toBe 2

    it 'should have a reset function', ->
      expect(typeof test.EventSpy::reset).toBe 'function'

    it 'should wipe counts on calling reset', ->
      m = new Backbone.Model
      s = new test.EventSpy m, 'event'
      expect(s.triggered).toBe false
      expect(s.triggerCount).toBe 0
      m.trigger 'event'
      expect(s.triggered).toBe true
      expect(s.triggerCount).toBe 1
      m.trigger 'event'
      expect(s.triggered).toBe true
      expect(s.triggerCount).toBe 2

      s.reset()
      expect(s.triggered).toBe false
      expect(s.triggerCount).toBe 0
      m.trigger 'event'
      expect(s.triggered).toBe true
      expect(s.triggerCount).toBe 1

    it 'should support spying on all events', ->
      m = new Backbone.Model
      s = new test.EventSpy m, 'all'
      expect(s.triggerCount).toBe 0
      m.trigger 'event'
      expect(s.triggerCount).toBe 1
      m.trigger 'otherevent'
      expect(s.triggerCount).toBe 2
      m.trigger 'yetanotherevent'
      expect(s.triggerCount).toBe 3
      m.trigger 'event'
      expect(s.triggerCount).toBe 4

    it 'should track the arguments of event calls', ->
      m = new Backbone.Model
      s = new test.EventSpy m, 'all'
      expect(s.arguments).toEqual []
      m.trigger 'a'
      expect(s.arguments).toEqual [['a']]
      m.trigger 'b', 1
      expect(s.arguments).toEqual [['a'], ['b', 1]]
      m.trigger 'c', 'hi', 'hello'
      expect(s.arguments).toEqual [['a'], ['b', 1], ['c', 'hi', 'hello']]

    it 'should wipe the arguments on calling reset', ->
      m = new Backbone.Model
      s = new test.EventSpy m, 'all'
      expect(s.arguments).toEqual []
      m.trigger 'a'
      expect(s.arguments).toEqual [['a']]
      m.trigger 'b', 1
      expect(s.arguments).toEqual [['a'], ['b', 1]]
      m.trigger 'c', 'hi', 'hello'
      expect(s.arguments).toEqual [['a'], ['b', 1], ['c', 'hi', 'hello']]

      s.reset()
      expect(s.arguments).toEqual []
      m.trigger 'b', {pedro: 'ah'}
      expect(s.arguments).toEqual [['b', {pedro: 'ah'}]]


  describe 'expectEventSpyBehaviors', ->

    it 'should be a function', ->
      expect(typeof test.expectEventSpyBehaviors).toBe 'function'

    it 'should test that events were triggered', ->
      m = new Backbone.Model
      spies =
        seeSpy: new test.EventSpy m, 'see'
        hearSpy: new test.EventSpy m, 'hear'
        speakSpy: new test.EventSpy m, 'speak'
        allSpy: new test.EventSpy m, 'all'

      fns = [
        ->
          m.trigger 'see'
          expectations =
            seeSpy: undefined
            allSpy: undefined
        ->
          m.trigger 'hear'
          expectations =
            hearSpy: undefined
            allSpy: undefined
        ->
          m.trigger 'speak'
          expectations =
            speakSpy: undefined
            allSpy: undefined
        ->
          m.trigger 'see'
          m.trigger 'hear'
          expectations =
            seeSpy: undefined
            hearSpy: undefined
            allSpy: undefined
        ->
          m.trigger 'see'
          m.trigger 'hear'
          m.trigger 'speak'
          expectations =
            seeSpy: undefined
            hearSpy: undefined
            speakSpy: undefined
            allSpy: undefined
      ]

      test.expectEventSpyBehaviors spies, fns

    it 'should test that events were triggered with specific arguments', ->
      m = new Backbone.Model
      spies =
        seeSpy: new test.EventSpy m, 'see'
        hearSpy: new test.EventSpy m, 'hear'
        speakSpy: new test.EventSpy m, 'speak'
        allSpy: new test.EventSpy m, 'all'

      fns = [
        ->
          evil = 'murdering children'
          m.trigger 'see', evil
          expectations =
            seeSpy: evil
            allSpy: ['see', evil]
        ->
          evil = 'tripping an old lady'
          m.trigger 'hear', evil
          expectations =
            hearSpy: evil
            allSpy: ['hear', evil]
        ->
          evil = 'stealing candy from children'
          m.trigger 'speak', evil
          expectations =
            speakSpy: evil
            allSpy: ['speak', evil]
        ->
          evil = 'slipping a laxative into the bake sale cookies'
          m.trigger 'hear', evil
          m.trigger 'speak', evil
          expectations =
            hearSpy: evil
            speakSpy: evil
            allSpy: ['speak', evil]
        ->
          evil = 'throwing a red ball in front of a blind man\'s guide dog, and
              yelling fetch'
          m.trigger 'speak', evil
          m.trigger 'hear', evil
          m.trigger 'see', evil
          expectations =
            seeSpy: evil
            hearSpy: evil
            speakSpy: evil
            allSpy: ['see', evil]
      ]

      test.expectEventSpyBehaviors spies, fns

