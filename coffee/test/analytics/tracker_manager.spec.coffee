goog.provide 'athena.lib.specs.TrackerManager'

goog.require 'athena.lib.TrackerManager'
goog.require 'athena.lib.MixpanelTracker'


describe 'athena.lib.TrackerManager', ->
  MixpanelTracker = athena.lib.MixpanelTracker
  TrackerManager = athena.lib.TrackerManager

  # test token
  token = 'b181ad1cf497c19278129c07d6f0c632'

  # function to construct a TrackerManager
  construct_fn = ->
    mixpanel_tracker = new MixpanelTracker(token)
    tracker_manager = new TrackerManager()
    tracker_manager.addTracker(mixpanel_tracker)
    tracker_manager

  it 'should exist', ->
    expect(TrackerManager).toBeDefined()

  it 'should be constructible', ->
    expect(construct_fn).not.toThrow();

  it 'should allow tracking', ->
    tracker = construct_fn()
    track_fn = ->
      tracker.track('event')
    expect(track_fn).not.toThrow();
