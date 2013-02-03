goog.provide 'athena.lib.specs.PopoverView'
goog.require 'athena.lib.util.test'
goog.require 'athena.lib.PopoverView'

describe 'PopoverView', ->
  PopoverView = athena.lib.PopoverView
  test = athena.lib.util.test

  options = popover: $('body')

  test.describeView PopoverView, athena.lib.View, options


  it 'should be part of athena.lib', ->
    expect(PopoverView).toBeDefined()


  it 'should look good', ->
    # create a div to safely append content to the page

    $safe = $('<div>').addClass('athena-lib-test').appendTo('body')
    $safe.append $('<div class="foo">Foo</div>').width('50')
    $safe.append $('<div class="bar">Bar</div>').width('50')

    view = new PopoverView
      content: new athena.lib.LoadingView
      popover: $('.athena-lib-test').children('.foo')
    view.render()

    view = new PopoverView
      title: 'Loading'
      content: new athena.lib.LoadingView
      popover: $('.athena-lib-test').children('.bar')
    view.render()

