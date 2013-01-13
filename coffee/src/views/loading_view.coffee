goog.provide 'athena.lib.LoadingView'
goog.require 'athena.lib.View'

# renders a loading indicator.
class athena.lib.LoadingView extends athena.lib.View


  className: @classNameExtend 'loading-view'


  defaults: => _.extend super,

    # the image to use
    img: '//athena.ai/img/gray-a-logo.png'

  render: =>
    super
    @$el.empty()
    @$el.append $('<img>').attr 'src', @options.img
    @$el.append 'Loading . . .'
    @


  renderLoading: =>
    @$('img').transition @options.animation
    @
