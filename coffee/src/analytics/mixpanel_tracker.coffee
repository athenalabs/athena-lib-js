goog.provide 'athena.lib.MixpanelTracker'

goog.require 'athena.lib.TrackerInterface'


class athena.lib.MixpanelTracker extends athena.lib.TrackerInterface

  constructor: (token, config) ->
    unless window.mixpanel?
      @bootstrap()
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

  bootstrap: =>
    # this is the mixpanel bootstrap script. loads lib async and queues calls.
    # see https://mixpanel.com/docs/people-analytics/javascript
    `(function(c,a){window.mixpanel=a;var b,d,h,e;b=c.createElement("script");
    b.type="text/javascript";b.async=!0;b.src=("https:"===c.location.protocol?"https:":"http:")+
    '//cdn.mxpnl.com/libs/mixpanel-2.2.min.js';d=c.getElementsByTagName("script")[0];
    d.parentNode.insertBefore(b,d);a._i=[];a.init=function(b,c,f){function d(a,b){
    var c=b.split(".");2==c.length&&(a=a[c[0]],b=c[1]);a[b]=function(){a.push([b].concat(
    Array.prototype.slice.call(arguments,0)))}}var g=a;"undefined"!==typeof f?g=a[f]=[]:
    f="mixpanel";g.people=g.people||[];h=['disable','track','track_pageview','track_links',
    'track_forms','register','register_once','unregister','identify','alias','name_tag',
    'set_config','people.set','people.increment','people.track_charge','people.append'];
    for(e=0;e<h.length;e++)d(g,h[e]);a._i.push([b,c,f])};a.__SV=1.2;})(document,window.mixpanel||[])
    `
