goog.provide 'athena.lib.specs.NullTracker'

goog.require 'athena.lib.NullTracker'


describe 'athena.lib.NullTracker', ->
  NullTracker = athena.lib.NullTracker

  it 'should exist', ->
    expect(NullTracker).toBeDefined()

  it 'should be constructible', ->
    construct_fn = ->
      new NullTracker()

    expect(construct_fn).not.toThrow()

  it 'should allow tracking', ->
    tracker = new NullTracker()
    track_fn = ->
      tracker.track('event', 'page', 'view')
    expect(track_fn).not.toThrow()
