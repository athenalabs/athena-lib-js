goog.provide 'athena.lib.NavListTabView'
goog.require 'athena.lib.NavListView'
goog.require 'athena.lib.View'

# renders one subview at a time, selecting between them using a NavListView
class athena.lib.NavListTabView extends athena.lib.View


  className: @classNameExtend 'nav-list-tab-view row-fluid'


  template: _.template '''
    <div class="nav-list-tab-side span4"></div>
    <div class="nav-list-tab-content span8"></div>
    '''


  defaults: => _.extend super,
    # nav list items to render
    items: []

    # views to select between { item.id: view }
    views: {}

    # initially selected id
    selected: undefined


  initialize: =>
    super

    @selected = @options.selected

    # clone to avoid mangling options
    @views = _.clone @options.views

    @navListView = new athena.lib.NavListView
      eventhub: @eventhub
      items: @options.items

    @listenTo @navListView, 'NavList:Select', (nav, id) => @select id


  render: =>
    super
    @$el.empty()
    @$el.html @template()
    @$('.nav-list-tab-side').append @navListView.render().el
    @renderView @selected
    @


  renderView: (id) =>
    @navListView.highlightItem id
    view = @views[id]
    if view
      @$('.nav-list-tab-content').append view.render().el
    @


  select: (id) =>
    @views[@selected]?.remove?()
    @selected = id
    if @rendering
      @renderView id
    @trigger 'NavListTab:Select', @, id
    @
