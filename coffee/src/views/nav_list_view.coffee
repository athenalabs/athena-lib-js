goog.provide 'athena.lib.NavListView'
goog.require 'athena.lib.View'

# renders a topbar navigation view
class athena.lib.NavListView extends athena.lib.View


  className: @classNameExtend 'nav-list-view well'


  template: _.template '''
    <ul class="nav nav-list"></ul>
    '''


  events: => _.extend super,
    'click li[data-nav]': @onSelectElement


  defaults: => _.extend super,

    # whether anchor links are followed or trigger an event
    followLinks: false

    # nav list items to render
    items: []



  initialize: =>
    super
    # clone items to avoid mangling options.items
    @items = _.clone @options.items


  render: =>
    super
    @$el.empty()
    @$el.html @template()
    @$el.css 'padding', '8px 0px'

    for item in @items
      @$('ul').append @renderItem(item)
    @


  renderItem: (item) =>
    $elem = $('<li>')
    $elem.addClass(item.className) if item.className
    $elem.attr('data-nav', item.id) if item.id

    if item.leftIcon
      $elem.append $('<i>').addClass item.leftIcon

    $elem.append $('<span>').append item.text

    if item.rightIcon
      $elem.append $('<i>').addClass item.rightIcon

    if item.link
      $link = $('<a>').attr 'href', item.link
      $link.append $elem.children()
      $elem.append $link

    $elem


  # item selector by id
  $item: (id) =>
    @$("li[data-nav='#{id}']")


  highlightItem: (id) =>
    # unhighlight all
    elems = @$ 'li'
    elems.removeClass 'active'
    elems.find('i').removeClass 'icon-white'

    # highlight selected
    item = @$item(id)
    item.addClass 'active'
    item.find('i').addClass 'icon-white'
    @


  selectItem: (id) =>
    unless (_.find @items, (item) -> item.id == id)
      throw new Error "No item with id '#{id}'"

    @trigger 'NavList:Select', @, id
    @highlightItem id
    @


  # triggered when clicking on the items
  onSelectElement: (event) =>
    if @options.followLinks
      return

    id = $(event.target.parentElement).attr 'data-nav'
    @selectItem id

    # ensure clicking anchor doesn't go through
    event.preventDefault()
    return false
