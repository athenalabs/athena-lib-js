goog.provide 'athena.lib.TrackerManager'

goog.require 'athena.lib.TrackerInterface'

# Athena Analitics Tracker Manager;
# Manages a set of trackers that inherit from athena.lib.TrackerInterface
class athena.lib.TrackerManager extends athena.lib.TrackerInterface

  addTracker: (tracker) =>
    @trackers ?= []
    @trackers.push(tracker)

  identify: (userid) =>
    for tracker in @trackers
      do (tracker) -> tracker.identify userid

  track: (name, properties, success) =>
    for tracker in @trackers
      do (tracker) -> tracker.track name, properties, success

  register: (dict) =>
    for tracker in @trackers
      do (tracker) -> tracker.register dict

  unregister: (property) =>
    for tracker in @trackers
      do (tracker) -> tracker.unregister property

  disable: (events) =>
    for tracker in @trackers
      do (tracker) -> tracker.disable events
