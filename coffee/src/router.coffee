goog.provide 'athena.lib.Router'

# Backbone.Router that listens to events on an eventhub
class athena.lib.Router extends Backbone.Router

  initialize: (options) =>
    super
    @options = options ? {}
    @eventhub = @options.eventhub ? @
    @app = @options.app

    # listen to Go events, which provide a URL to navigate to
    @eventhub.on 'Go', (url) => @go url


  go: (url) =>
    unless url?
      throw new Error 'Router::go requires a `url` parameter'

    # if absolute url, navigate the browser to another page
    if !! url.match /^(https?:)?\/\//i
      @navigateBrowser url
      return

    # otherwise, just navigate the router
    @navigate url, trigger: true


  navigateBrowser: (url) =>
    window.location.href = url


  # captures all links and routes them iff they are under the same origin,
  # (instead of causing a browser a page-load.)
  routeInternalLinks: =>

    # needed in the function below (not bound, need to preserve `this`)
    router = @

    $(document).on 'click', 'a:not([data-bypass])', (event) ->

      # target must be an anchor tag
      unless @nodeName.toLowerCase() is 'a'
        return event

      # origin must be our origin (or this is not local)
      unless @origin is window.location.origin
        return event

      # prevent href from triggering a page reload
      event.preventDefault()

      # navigate to the route described by path
      router.navigate @pathname, trigger: true
