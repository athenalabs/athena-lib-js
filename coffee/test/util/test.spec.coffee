goog.provide 'athena.lib.util.test.spec'

goog.require 'athena.lib.util.test'

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
