goog.provide 'athena.lib.GoogleAnalyticsTracker'

goog.require 'athena.lib.TrackerInterface'


class athena.lib.GoogleAnalyticsTracker extends athena.lib.TrackerInterface

  constructor: (tracking_id, config) ->
    unless google_analytics?
      @bootstrap()

    @tracking_id = tracking_id
    @exclude = []

    google_analytics 'create', tracking_id, config


  track: (name, properties, success) =>
    if _.contains @exclude, name
      return

    properties = _.clone(properties) || {}
    properties.hitType = name
    if success?
      properties.hitCallback = success

    google_analytics 'send', properties


  disable: (events) =>
    if events?
      @exclude.concat events
      @exclude = _.uniq(@exclude)

    else
      window['ga-disable-' + token] = true


  identify: (userid) =>
    # pass; not supported


  register: (dict) =>
    # pass; not supported


  unregister: (property) =>
    # pass; not supported


  bootstrap: =>
    `(function(i, s, o, g, r, a, m) {
      i['GoogleAnalyticsObject'] = r;
      i[r] = i[r] || function() {
        (i[r].q = i[r].q || []).push(arguments)
      }, i[r].l = 1 * new Date();
      a = s.createElement(o),
      m = s.getElementsByTagName(o)[0];
      a.async = 1;
      a.src = g;
      m.parentNode.insertBefore(a, m)
    })(window, document, 'script',
       '//www.google-analytics.com/analytics.js', 'google_analytics');`
