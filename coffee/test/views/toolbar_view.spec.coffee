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

  it 'should render and append button groups', ->
    btns = [['Button1', 'Button2']]
    view = new ToolbarView(buttons: btns)
    expect(view.buttons).toBe btns

    view.render()
    text = view.$('button').text().replace(/\s+/g, '')
    expect(text).toBe 'Button1Button2'
    expect(view.$('.btn-group').children().length).toBe 2

  it 'should look good', ->
    # create a div to safely append content to the page
    $safe = $('<div>').addClass('athena-lib-test').appendTo('body')

    btns = ['Cancel', {text: 'Save', className: 'btn-success'}]
    view = new ToolbarView buttons: btns
    view.render()
    $safe.append view.el
