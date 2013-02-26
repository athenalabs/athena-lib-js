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


  describe 'PopoverView::show', ->

    it 'should have a show method', ->
      expect(typeof PopoverView::show).toBe 'function'

    it 'should track showing state correctly when shown', ->
      view = new PopoverView
        content: new athena.lib.LoadingView
        popover: $('.athena-lib-test').children('.foo')
      view.render()

      view.showing = false
      expect(view.showing).toBe false
      view.show()
      expect(view.showing).toBe true

    it 'should announce that it showed on show', ->
      view = new PopoverView
        content: new athena.lib.LoadingView
        popover: $('.athena-lib-test').children('.foo')
      view.render()
      spy = new test.EventSpy view, 'PopoverView:PopoverDidShow'

      expect(spy.triggerCount).toBe 0
      view.show()
      expect(spy.triggerCount).toBe 1

    it 'should be a no-op if not rendering', ->
      view = new PopoverView
        content: new athena.lib.LoadingView
        popover: $('.athena-lib-test').children('.foo')
      spy = new test.EventSpy view, 'PopoverView:PopoverDidShow'

      expect(spy.triggerCount).toBe 0
      view.show()
      expect(spy.triggerCount).toBe 0


  describe 'PopoverView::hide', ->

    it 'should have a hide method', ->
      expect(typeof PopoverView::hide).toBe 'function'

    it 'should track showing state correctly when hidden', ->
      view = new PopoverView
        content: new athena.lib.LoadingView
        popover: $('.athena-lib-test').children('.foo')
      view.render()

      view.showing = true
      expect(view.showing).toBe true
      view.hide()
      expect(view.showing).toBe false

    it 'should announce that it hid on hide', ->
      view = new PopoverView
        content: new athena.lib.LoadingView
        popover: $('.athena-lib-test').children('.foo')
      view.render()
      spy = new test.EventSpy view, 'PopoverView:PopoverDidHide'

      expect(spy.triggerCount).toBe 0
      view.hide()
      expect(spy.triggerCount).toBe 1

    it 'should be a no-op if not rendering', ->
      view = new PopoverView
        content: new athena.lib.LoadingView
        popover: $('.athena-lib-test').children('.foo')
      spy = new test.EventSpy view, 'PopoverView:PopoverDidHide'

      expect(spy.triggerCount).toBe 0
      view.hide()
      expect(spy.triggerCount).toBe 0


  describe 'PopoverView::toggle', ->

    it 'should have a toggle method', ->
      expect(typeof PopoverView::toggle).toBe 'function'

    it 'should track showing state correctly when toggled', ->
      view = new PopoverView
        content: new athena.lib.LoadingView
        popover: $('.athena-lib-test').children('.foo')
      view.render()

      view.showing = false
      expect(view.showing).toBe false
      view.toggle()
      expect(view.showing).toBe true
      view.toggle()
      expect(view.showing).toBe false

    it 'should announce that it showed when toggle shows it', ->
      view = new PopoverView
        content: new athena.lib.LoadingView
        popover: $('.athena-lib-test').children('.foo')
      view.render()
      spy = new test.EventSpy view, 'PopoverView:PopoverDidShow'

      view.showing = false
      expect(spy.triggerCount).toBe 0
      view.toggle()
      expect(spy.triggerCount).toBe 1

    it 'should announce that it hid when toggle hides it', ->
      view = new PopoverView
        content: new athena.lib.LoadingView
        popover: $('.athena-lib-test').children('.foo')
      view.render()
      spy = new test.EventSpy view, 'PopoverView:PopoverDidHide'

      view.showing = true
      expect(spy.triggerCount).toBe 0
      view.toggle()
      expect(spy.triggerCount).toBe 1

    it 'should be a no-op if not rendering', ->
      view = new PopoverView
        content: new athena.lib.LoadingView
        popover: $('.athena-lib-test').children('.foo')
      showSpy = new test.EventSpy view, 'PopoverView:PopoverDidShow'
      hideSpy = new test.EventSpy view, 'PopoverView:PopoverDidHide'

      expect(showSpy.triggerCount).toBe 0
      expect(hideSpy.triggerCount).toBe 0
      view.trigger()
      expect(showSpy.triggerCount).toBe 0
      expect(hideSpy.triggerCount).toBe 0


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

