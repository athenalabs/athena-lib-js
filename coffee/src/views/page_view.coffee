goog.provide 'athena.lib.PageView'
goog.require 'athena.lib.ContainerView'

# view for rendering distinct pages (large units) of an application
class athena.lib.PageView extends athena.lib.ContainerView

  className: @classNameExtend 'page-view'


  defaults: => _.extend super,
    refreshScroll: true


  render: =>
    super

    if @options.refreshScroll
      scrollTo 0, 0

    @
