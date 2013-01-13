goog.provide 'athena.lib.NavigationView'
goog.require 'athena.lib.View'

# renders a topbar navigation view
class athena.lib.NavigationView extends athena.lib.View


  className: @classNameExtend 'navigation-view navbar'


  template: _.template '''
    <div class="navbar-inner">
      <% if (brand) { %>
        <a class="brand" href="#"><%= brand %></a>
      <% } %>
      <ul class="nav toolbar-view pull-right"></ul>
    </div>
    '''


  defaults: => _.extend super,
    # brand title
    brand: ''

    # right-side toolbar elements
    buttons: []


  initialize: =>
    super

    @toolbarView = new athena.lib.ToolbarView
      eventhub: @eventhub
      buttons: @options.buttons


  render: =>
    super
    @$el.empty()
    @$el.html @template
      brand: @options.brand

    @toolbarView.setElement @$('.toolbar-view')
    @toolbarView.render()

    @
