goog.provide 'athena.lib.MixpanelTracker'

goog.require 'athena.lib.TrackerInterface'


class athena.lib.MixpanelTracker extends athena.lib.TrackerInterface

  constructor: (token, config) ->
    mixpanel.init token, config

  identify: (userid) =>
    mixpanel.identify userid
    mixpanel.people.set 'username', userid
    mixpanel.name_tag userid

  track: (name, properties, success) =>
    mixpanel.track name, properties, success

  register: (dict) =>
    mixpanel.register dict

  unregister: (property) =>
    mixpanel.unregister property

  disable: (events) =>
    mixpanel.disable events
