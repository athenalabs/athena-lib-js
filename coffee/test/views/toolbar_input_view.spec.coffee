goog.provide 'athena.lib.specs.ToolbarInputView'
goog.require 'athena.lib.ToolbarInputView'
goog.require 'athena.lib.util.keys'

describe 'athena.lib.ToolbarInputView', ->
  ToolbarInputView = athena.lib.ToolbarInputView
  keys = athena.lib.util.keys
  test = athena.lib.util.test

  it 'should be part of athena.lib', ->
    expect(ToolbarInputView).toBeDefined()


  test.describeView ToolbarInputView, athena.lib.InputView, ->

    it 'should have tagName div', ->
      expect(ToolbarInputView::tagName).toBe 'div'

    it 'should look good and work well', ->
      # create a div to safely append content to the page
      $safe = $('<div>').addClass('athena-lib-test').appendTo('body')

      buttons = ['Cancel', 'Save']
      view = new ToolbarInputView buttons: buttons
      view.render()
      view.$el.css('margin', '20px').css('display', 'block')
      $safe.append view.$el
      view


    test.describeDefaults ToolbarInputView,
      buttons: []


    describe 'ToolbarInputView::elAttributes', ->

      it 'should be empty', ->
        _.each [{}, {buttons: ['Foo', 'Bar']}], (set) ->
          view = new ToolbarInputView set
          expect(view.elAttributes()).toEqual {}


  describe 'ToolbarInputView::value', ->

    it 'should be a function', ->
      expect(typeof InputView::value).toBe 'function'

    it 'should always return undefined (store no value)', ->
      view = new ToolbarInputView
      _.each ['foo', 'bar', 'baz', '{}', '[1, 2, 3]'], (val) ->
        expect(view.value()).not.toBeDefined()
        expect(view.value(val)).not.toBeDefined()
        expect(view.value()).not.toBeDefined()

  test.describeSubview
    View: ToolbarInputView
    subviewAttr: 'toolbarView'
    Subview: athena.lib.ToolbarView

  it 'should proxy all subclass events.', ->
    view = new ToolbarInputView
    spy = new test.EventSpy view, 'all'
    foo = new test.EventSpy view, 'foo'
    view.toolbarView.trigger 'foo'
    expect(spy.triggerCount).toBe 1
    expect(foo.triggerCount).toBe 1
    view.toolbarView.trigger 'bar'
    expect(spy.triggerCount).toBe 2
    view.toolbarView.trigger 'baz'
    expect(spy.triggerCount).toBe 3
    view.toolbarView.trigger 'foo'
    expect(spy.triggerCount).toBe 4
    expect(foo.triggerCount).toBe 2
