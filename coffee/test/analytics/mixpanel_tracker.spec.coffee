goog.provide 'athena.lib.specs.MixpanelTracker'

goog.require 'athena.lib.MixpanelTracker'


describe 'window.mixpanel library', ->
  it 'should exist', ->
    expect(window.mixpanel).toBeDefined()

describe 'athena.lib.MixpanelTracker', ->
  MixpanelTracker = athena.lib.MixpanelTracker

  # test token
  token = 'b181ad1cf497c19278129c07d6f0c632'

  it 'should exist', ->
    expect(MixpanelTracker).toBeDefined()

  it 'should be constructible', ->
    construct_fn = ->
      new MixpanelTracker(token)

    expect(construct_fn).not.toThrow();

  it 'should allow tracking', ->
    tracker = new MixpanelTracker(token)
    track_fn = ->
      tracker.track('event')
    expect(track_fn).not.toThrow();
