goog.provide 'athena.lib.LoadingView'
goog.require 'athena.lib.View'

# renders a loading indicator.
class athena.lib.LoadingView extends athena.lib.View


  className: @classNameExtend 'loading-view'


  defaults: => _.extend super,

    # the image to use
    img: 'http://athena.ai/img/gray-a-logo.png'

  render: =>
    super
    @$el.empty()
    @$el.append $('<img>').attr 'src', @options.img
    @$el.append 'Loading <span class="progress-display"></span>'
    @startProgress()

    @


  destroy: =>
    @stopProgress()
    super


  updateProgress: =>
    @progressCount = (@progressCount + 1) % 4

    progress = ''
    for i in [0...@progressCount]
      progress += '. '

    @display.text progress


  startProgress: (ms = 500) =>
    @display = @$ 'span.progress-display'
    @progressCount = 0
    @progressInterval = setInterval @updateProgress, ms


  stopProgress: =>
    clearInterval @progressInterval


  renderLoading: =>
    @$('img').transition @options.animation
    @
