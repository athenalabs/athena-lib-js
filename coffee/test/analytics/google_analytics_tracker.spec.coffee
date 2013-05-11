goog.provide 'athena.lib.specs.GoogleAnalyticsTracker'

goog.require 'athena.lib.GoogleAnalyticsTracker'


describe 'athena.lib.GoogleAnalyticsTracker', ->
  GoogleAnalyticsTracker = athena.lib.GoogleAnalyticsTracker

  # test tracker_id
  tracker_id = 'UA-40841958-1'

  it 'should exist', ->
    expect(GoogleAnalyticsTracker).toBeDefined()

  it 'should be constructible', ->
    construct_fn = ->
      new GoogleAnalyticsTracker(tracker_id, { 'cookieDomain': 'none' })

    expect(construct_fn).not.toThrow()

  it 'should allow tracking', ->
    tracker = new GoogleAnalyticsTracker(tracker_id, { 'cookieDomain': 'none' })
    track_fn = ->
      tracker.track('event', 'page', 'view')
    expect(track_fn).not.toThrow()
