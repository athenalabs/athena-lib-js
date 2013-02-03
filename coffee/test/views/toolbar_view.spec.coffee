goog.provide 'athena.lib.ToolbarView.spec'

goog.require 'athena.lib.util'
goog.require 'athena.lib.ToolbarView'

describe 'ToolbarView', ->
  ToolbarView = athena.lib.ToolbarView

  test.describeView ToolbarView, athena.lib.View

  it 'should be part of athena.lib', ->
    expect(ToolbarView).toBeDefined()

  it 'should have a buttons attribute', ->
    btns = ['a', 'b']
    view = new ToolbarView(buttons: btns)
    expect(view.buttons).toBe btns

  it 'should render and append views', ->
    btn = new athena.lib.View()
    view = new ToolbarView buttons: [btn]
    expect(view.buttons[0]).toBe btn
    expect(btn.rendering).toBe false
    expect(btn.el.parentNode).not.toBe view.el

    view.render()
    expect(btn.rendering).toBe true
    expect(btn.el.parentNode).toBe view.el

  it 'should render and append selectors', ->
    btn = $ '<div>'
    view = new ToolbarView buttons: [btn]
    expect(view.buttons[0]).toBe btn
    expect(btn[0].parentNode).not.toBe view.el

    view.render()
    expect(btn[0].parentNode).toBe view.el

  it 'should render and append string', ->
    btn = 'Button'
    view = new ToolbarView(buttons: [btn])
    expect(view.buttons[0]).toBe btn

    view.render()
    expect(view.$('button').text()).toBe 'Button'


  describe 'button objects', ->

    it 'should render and append button objects', ->
      btn = text: 'Button'
      view = new ToolbarView(buttons: [btn])
      expect(view.buttons[0]).toBe btn

      view.render()
      expect(view.$('button').text()).toBe 'Button'

    it 'should support className in button objects', ->
      btn = text: 'Button', className: 'btn-success'
      view = new ToolbarView(buttons: [btn])
      view.render()
      expect(view.$('button').hasClass 'btn-success').toBe true
      expect(view.$('button').hasClass 'btn-error').toBe false

      btn = text: 'Button', className: 'btn-error'
      view = new ToolbarView(buttons: [btn])
      view.render()
      expect(view.$('button').hasClass 'btn-success').toBe false
      expect(view.$('button').hasClass 'btn-error').toBe true

    it 'should support id in button objects', ->
      btn = text: 'Button', id: 'the-best-btn-ever'
      view = new ToolbarView(buttons: [btn])
      view.render()
      expect(view.$('button').attr 'id').toBe 'the-best-btn-ever'

    it 'should support events in button objects', ->
      btn = text: 'Button', events: {click: ->}
      spy = spyOn(btn.events, 'click')

      view = new ToolbarView(buttons: [btn])
      view.render()

      expect(spy).not.toHaveBeenCalled()
      view.$('button').trigger 'click'
      expect(spy).toHaveBeenCalled()

    it 'should support icon in button objects', ->
      btn = text: 'Button', icon: 'icon-remove'
      view = new ToolbarView buttons: [btn]
      view.render()

      expect(view.$('button > i').hasClass 'icon-remove').toBe true

    it 'should support tooltips in button objects', ->
      spy = spyOn($.fn, 'tooltip').andCallThrough()
      btn = text: 'Button', tooltip: 'Tooltip!'
      view = new ToolbarView buttons: [btn]

      expect(spy).not.toHaveBeenCalled()
      view.render()
      expect(spy).toHaveBeenCalled()

  describe 'button groups', ->

    it 'should render and append button groups', ->
      btns = [['Button1', 'Button2']]
      view = new ToolbarView(buttons: btns)
      expect(view.buttons).toBe btns

      view.render()
      text = view.$('button').text().replace(/\s+/g, '')
      expect(text).toBe 'Button1Button2'
      expect(view.$('.btn-group').children().length).toBe 2

    it 'should render and append dropdown buttons', ->
      btn = text: 'Dropdown', dropdown: [{text: 'Foo'}, {text: 'Bar', id: 'b'}]
      view = new ToolbarView(buttons: [btn])
      expect(view.buttons).toEqual [btn]

      view.render()
      expect(view.$('button').text().replace(/\s+/g, '')).toBe 'Dropdown'
      expect(view.$('a').text().replace(/\s+/g, '')).toBe 'FooBar'
      expect(view.$('a#b').length).toBe 1
      expect(view.$('.dropdown-menu').children().length).toBe 2


  describe 'ToolbarView::button', ->
    it 'should be a function', ->
      expect(typeof ToolbarView::button).toBe 'function'

    it 'should return button with given id', ->
      btns = [{text: 'Foo', id: 'f'}, {text: 'Bar'}, {text: 'Baz', id: 'baz'}]
      view = new ToolbarView buttons: btns
      expect(view.button 'f').toBe btns[0]
      expect(view.button 'Bar').toBe undefined
      expect(view.button 'baz').toBe btns[2]

      view = new ToolbarView buttons: [btns]
      expect(view.button 'f').toBe btns[0]
      expect(view.button 'Bar').toBe undefined
      expect(view.button 'baz').toBe btns[2]


  describe 'ToolbarView events', ->

    it 'should trigger events on btn clicks', ->
      btns = [{text: 'Foo', id: 'foo'}, {text: 'Bar', id: 'bar'}]
      view = new ToolbarView buttons: btns
      spy1 = new test.EventSpy view, 'Toolbar:Click'
      spy2 = new test.EventSpy view, 'Toolbar:Click:foo'
      spy3 = new test.EventSpy view, 'Toolbar:Click:bar'
      view.render()

      view.$('#foo').trigger 'click'
      expect(spy1.triggerCount).toBe 1
      expect(spy2.triggerCount).toBe 1

      view.$('#bar').trigger 'click'
      expect(spy1.triggerCount).toBe 2
      expect(spy3.triggerCount).toBe 1

      view.$('#foo').trigger 'click'
      expect(spy1.triggerCount).toBe 3
      expect(spy2.triggerCount).toBe 2


    it 'should trigger events on dropdown link clicks', ->
      btns = [{text: 'Foo', id:'foo', dropdown: [{text: 'Bar', id: 'bar'}]}]
      view = new ToolbarView buttons: btns
      spy1 = new test.EventSpy view, 'Toolbar:Click'
      spy2 = new test.EventSpy view, 'Toolbar:Click:foo'
      spy3 = new test.EventSpy view, 'Toolbar:Click:bar'
      spy4 = new test.EventSpy view, 'Toolbar:Click:foo:bar'
      view.render()

      view.$('#foo .dropdown-toggle').trigger 'click'
      expect(spy1.triggerCount).toBe 1
      expect(spy2.triggerCount).toBe 1

      view.$('#bar').trigger 'click'
      expect(spy1.triggerCount).toBe 2
      expect(spy3.triggerCount).toBe 1
      expect(spy4.triggerCount).toBe 1


    it 'should trigger events on btn.i clicks', ->
      btns = [
        {text: 'Foo', id: 'foo', icon: 'icon-ok'},
        {text: 'Bar', id: 'bar', icon: 'icon-cancel'}
      ]
      view = new ToolbarView buttons: btns
      spy1 = new test.EventSpy view, 'Toolbar:Click'
      spy2 = new test.EventSpy view, 'Toolbar:Click:foo'
      spy3 = new test.EventSpy view, 'Toolbar:Click:bar'
      view.render()

      view.$('#foo > i').trigger 'click'
      expect(spy1.triggerCount).toBe 1
      expect(spy2.triggerCount).toBe 1

      view.$('#bar > i').trigger 'click'
      expect(spy1.triggerCount).toBe 2
      expect(spy3.triggerCount).toBe 1

      view.$('#foo > i').trigger 'click'
      expect(spy1.triggerCount).toBe 3
      expect(spy2.triggerCount).toBe 2


    it 'should trigger events on dropdown link.i clicks', ->
      drop = [{text: 'Bar', id: 'bar', leftIcon: 'icon-cancel'}]
      btns = [{text: 'Foo', id:'foo', icon: 'icon-ok', dropdown: drop}]
      view = new ToolbarView buttons: btns
      spy1 = new test.EventSpy view, 'Toolbar:Click'
      spy2 = new test.EventSpy view, 'Toolbar:Click:foo'
      spy3 = new test.EventSpy view, 'Toolbar:Click:bar'
      spy4 = new test.EventSpy view, 'Toolbar:Click:foo:bar'
      view.render()

      view.$('#foo .dropdown-toggle > i.icon-ok').trigger 'click'
      expect(spy1.triggerCount).toBe 1
      expect(spy2.triggerCount).toBe 1

      view.$('#bar > i.icon-cancel').trigger 'click'
      expect(spy1.triggerCount).toBe 2
      expect(spy3.triggerCount).toBe 1
      expect(spy4.triggerCount).toBe 1



  it 'should look good', ->
    # create a div to safely append content to the page
    $safe = $('<div>').addClass('athena-lib-test').appendTo('body')

    btns = [
      'Cancel',
      {text: 'Save', className: 'btn-success', tooltip:'yay'},
      {text: 'Delete', icon: 'icon-remove'},
      {icon: 'icon-remove', tooltip: {title: 'bye bye', delay: {show: 1000}}},
      [['Foo', 'Bar']],
      {text: 'Foo', id: 'foo', dropdown: [
        {text: 'Bar', id:'b'}, {text: 'Baz', id:'c'}
      ]}
    ]
    view = new ToolbarView buttons: btns
    view.render()
    $safe.append view.el
