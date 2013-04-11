goog.provide 'athena.lib.util'

util = athena.lib.util

# Helper to check the inheritance chain.
util.derives = derives = (child, parent) ->

  if !child || !child.__super__
    return false

  if parent.prototype is child.__super__
    return true

  derives child.__super__.constructor, parent

util.isOrDerives = (child, parent) ->
  child == parent or derives child, parent

util.isStrictObject = (obj) ->
  obj?.toString() == '[object Object]'


# Check if an element or set of elements is in the DOM
util.elementInDom = (element) ->
  if element instanceof $
    return _.all element, util.elementInDom

  while element = element?.parentNode
    if element == document
      return true

  return false


util.socialPlugins =

  initialize: (options = {}) ->
    # facebook async setup - requires appId param
    if options.facebook?.appId
      window.fbAsyncInit = ->
        FB.init
          appId: options.facebook.appId
          channelUrl: options.facebook.channelUrl # optional url; smooths x-domain
          status: options.facebook.status ? true # check login status
          cookie: options.facebook.cookie ? true # enable cookies
          xfbml: options.facebook.xfbml ? true # parse XFBML

        options.facebook.onInit?()

    # include relevant plugin scripts

    scriptParams = []

    if options.facebook?.appId
      scriptParams.push
        id: 'facebook-jssdk'
        src: '//connect.facebook.net/en_US/all.js'
        async: true

    if options.googlePlus
      scriptParams.push
        id: 'g-plus1'
        src: 'https://apis.google.com/js/plusone.js'
        async: true

    if options.twitter
      scriptParams.push
        id: 'twitter-wjs'
        src: 'https://platform.twitter.com/widgets.js'

    # build and insert script tags
    for params in scriptParams
      unless document.getElementById params.id
        ref = document.getElementsByTagName('script')[0]
        script = document.createElement 'script'
        script.type = 'text/javascript'
        script.id = params.id
        script.src = params.src
        if params.async
          script.async = true
        ref.parentNode.insertBefore script, ref


  facebookLogin: (options = {}) ->
    login = () ->
      FB.login (response) ->
        if response.authResponse
          # connected
          options.success?()
        else
          # cancelled
          options.failure?()

    FB.getLoginStatus (response) ->
      if response.status == 'connected'
        # connected
        options.success?()
      else if response.status == 'not_authorized'
        # not authorized
        login()
      else
        # not logged in
        login()


  facebookPicture: (id, type = 'large') ->
    "//graph.facebook.com/#{id}/picture?type=#{type}"
