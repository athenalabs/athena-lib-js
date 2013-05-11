goog.provide 'athena.lib.specs.HeaderView'

goog.require 'athena.lib.util'
goog.require 'athena.lib.HeaderView'

describe 'athena.lib.HeaderView', ->
  HeaderView = athena.lib.HeaderView
  DirectiveView = athena.lib.DirectiveView
  ToolbarView = athena.lib.ToolbarView
  View = athena.lib.View

  test.describeView HeaderView, athena.lib.View, ->

    it 'should look good', ->
      # create a div to safely append content to the page
      $safe = $('<div>').addClass('athena-lib-test').appendTo('body')

      view = new HeaderView
        parts: ['Foo', 'Bar', 'Biz']
        buttons: [{text:'Foo'}, {text:'Bar'}, {text:'Biz'}]
      view.render()
      view.$el.css('margin', '20px').css('display', 'block')
      $safe.append view.$el


  test.describeSubview
    View: HeaderView
    subviewAttr: 'directiveView'
    Subview: DirectiveView
    viewOptions: {eventhub: new athena.lib.View}


  test.describeSubview
    View: HeaderView
    subviewAttr: 'toolbarView'
    Subview: ToolbarView
    viewOptions: {eventhub: new athena.lib.View}
