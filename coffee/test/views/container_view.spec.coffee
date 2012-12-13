goog.provide 'athena.lib.ContainerView.spec'

goog.require 'athena.lib.util'
goog.require 'athena.lib.ContainerView'

describe 'ContainerView', ->
  ContainerView = athena.lib.ContainerView

  test.describeView ContainerView, athena.lib.View

  it 'should be part of athena.lib', ->
    expect(ContainerView).toBeDefined()

  # create a div to safely append content to the page
  $testdiv = $('<div id="ContainerViewSpec">')
  $testdiv.appendTo $('body')
  $safe = (sel) -> $testdiv.find(sel)

  # util to turn a selector into html
  toHtml = (sel) -> $('<div>').append(sel.clone()).html();

  # sample content of different kinds to test with
  sample =
    view: new athena.lib.View()
    string: 'String Content'
    string_empty: ''
    selector_tag: $('div')
    selector_create: $('<a>')
    selector_empty: $('.class-that-doesnt-exist')
    template: {a:1, b:2}


  it 'should store content given to it', ->
    _.each sample, (value, type) ->
      expect(new ContainerView(content: value).content()).toBe value

  testRendering = (view_with_content) ->

    it 'should render simple strings', ->
      _.each ['a', 'b', 'String Content'], (str) ->
        view = new ContainerView content: str
        view.render()
        expect(view.$el.html()).toBe str

    it 'should render empty strings', ->
      view = new ContainerView content: sample.string_empty
      view.render()
      expect(view.$el.html()).toBe sample.string_empty


    it 'should render lookup selectors', ->
      _.each ['div', '.foo', ], (sel) ->
        $testdiv.append('<div class="foo">')
        $sel = $safe(sel)
        view = new ContainerView content: $sel
        view.render()
        expect(view.$el.html()).toBe toHtml($sel)

    it 'should render creation selectors', ->
      _.each ['div', 'a'], (sel) ->
        view = new ContainerView content: $("<#{sel}>")
        view.render()
        expect(view.$el.html()).toBe toHtml $("<#{sel}>")

    it 'should render empty selectors', ->
      _.each ['a', 'tagthatdoesntexist', '.classthatdoesntexist'], (sel) ->
        view = new ContainerView content: $safe(sel)
        view.render()
        expect(view.$el.html()).toBe toHtml $safe(sel)

    it 'should render templates', ->
      ContainerView::template = _.template 'a:<%= a %>,b:<%= b %>'
      _.each [[1, 2], ['aaa', 'bbb'], [new Date(), window]], (pairs) ->
        vars = {a: pairs[0], b: pairs[1]}
        view = new ContainerView content: vars
        view.render()
        expect(view.$el.html()).toBe ContainerView::template(vars)
        expect(view.$el.html()).toBe "a:#{vars.a},b:#{vars.b}"

    it 'should fail to render unsupported types of content', ->
      _.each [123, [1, 2, 3]], (unsupported) ->
        view = new ContainerView content: unsupported
        expect(view.render).toThrow()

  describe 'ContainerView content rendering (construct)', ->
    testRendering (content) -> new ContainerView content: content

  describe 'ContainerView content rendering (change)', ->
    view = new ContainerView()
    testRendering (content) ->
      view.content content
      view
