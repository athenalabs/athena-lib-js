goog.provide 'athena.lib.NullTracker'

goog.require 'athena.lib.TrackerInterface'


# Athena interface for wrappers over analytics frameworks.
class athena.lib.NullTracker extends athena.lib.TrackerInterface

  identify: (userid) =>
    # pass

  track: (name, properties, success, error) =>
    # pass

  register: (dict) =>
    # pass

  unregister: (property) =>
    # pass

  disable: (events) =>
    # pass
