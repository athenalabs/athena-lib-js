goog.provide 'athena.lib.specs.NavigationView'

goog.require 'athena.lib.util'
goog.require 'athena.lib.NavigationView'

describe 'athena.lib.NavigationView', ->
  NavigationView = athena.lib.NavigationView
  test = athena.lib.util.test

  it 'should be part of athena.lib', ->
    expect(NavigationView).toBeDefined()

  test.describeView NavigationView, athena.lib.View, ->

    it 'should look good', ->
      # create a div to safely append content to the page
      $safe = $('<div>').addClass('athena-lib-test').appendTo('body')

      link = (string) -> $("<li><a href='#'>#{string}</a></li>")
      view = new NavigationView
        brand: 'Foo'
        buttons: [ link('Foo'), link('Bar'), 'Baz']
      view.render()
      $safe.append view.$el

      view = new NavigationView
        brand: 'Athena Lib',
        buttons: [{text: 'Feedback', className: 'btn-success', tooltip:'yay'}]
        extraClasses: 'navbar-fixed-top'
      view.render()
      $safe.append view.$el

  test.describeDefaults NavigationView,
    brand: ''
    buttons: []

  test.describeSubview
    View: NavigationView
    subviewAttr: 'toolbarView'
    Subview: athena.lib.ToolbarView
    checkDOM: (child, parent) -> child.parentNode.parentNode is parent
