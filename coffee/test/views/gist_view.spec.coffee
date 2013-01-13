goog.provide 'athena.lib.specs.GistView'
goog.require 'athena.lib.util.test'
goog.require 'athena.lib.GistView'
goog.require 'athena.lib.DocView'

describe 'GistView', ->
  GistView = athena.lib.GistView
  DocView = athena.lib.DocView
  test = athena.lib.util.test


  test.describeView GistView, DocView


  test.describeDefaults GistView,
    gist: undefined
    files: undefined
    render: athena.lib.DocView.renderMarkdown


  it 'should be part of athena.lib', ->
    expect(GistView).toBeDefined()


  it 'should look good', ->
    # create a div to safely append content to the page
    $safe = $('<div>').addClass('athena-lib-test').appendTo('body')

    view = new GistView
      gist: '3c2278d7a5d8c22c94ba'
    view.render()
    $safe.append view.$el


  describe 'GistView::parseGist', ->

    gist =
      data:
        files:
          foo: content: 'Foo'
          bar: content: 'Bar'
          baz: content: 'Baz'

    it 'should concat gist files', ->
      view = new athena.lib.GistView
      result = view.parseGist gist
      expect(result).toBe 'Foo\n\nBar\n\nBaz'

    it 'should concat given files only', ->
      view = new athena.lib.GistView files: ['baz', 'foo']
      result = view.parseGist gist
      expect(result).toBe 'Baz\n\nFoo'

