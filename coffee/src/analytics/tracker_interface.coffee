goog.provide 'athena.lib.TrackerInterface'


# Athena interface for wrappers over analytics frameworks.
class athena.lib.TrackerInterface

  # Identifies a user with a unique ID. All subsequent events on this object
  # will be tied to this new identity. If this method is not called, users
  # will be identified by a UUID generated on first request.
  identify: (userid) =>
    throw Error "Method `identify` of class deriving
                 from TrackerInterface not implemented."

  # Track an event.
  # Parameters:
  # - name of the event to track, "button click", "user signup", etc.
  # - properties object to include with the event
  # - success (optional) callback that fires on success
  # - error (optional) callback that fires on error
  track: (name, properties, success, error) =>
    throw Error "Method `track` of class deriving
                 from TrackerInterface not implemented."

  # Stores a persistent set of properties for a user. These properties are
  # automatically included with all events sent by the user.
  # Parameters:
  # - dict object of properties to store
  register: (dict) =>
    throw Error "Method `register` of class deriving
                 from TrackerInterface not implemented."

  # Delete a previously registered property from this user if it exists.
  # Parameters:
  # - property name
  unregister: (property) =>
    throw Error "Method `unregister` of class deriving
                 from TrackerInterface not implemented."

  # Disable tracking for some or all events. If passed no arguments, this
  # function disables event tracking entirely. If passed an array of event
  # names, tracking is disabled for just those events.
  disable: (events) =>
    throw Error "Method `disable` of class deriving
                 from TrackerInterface not implemented."
