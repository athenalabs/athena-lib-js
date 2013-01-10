goog.provide 'athena.lib.specs.DocView'
goog.require 'athena.lib.util.test'
goog.require 'athena.lib.DocView'

describe 'DocView', ->
  DocView = athena.lib.DocView
  test = athena.lib.util.test


  test.describeView DocView, athena.lib.View


  test.describeDefaults DocView,
    doc: ''
    url: undefined
    # render: (doc) -> doc # describeDefaults fails on functions :(


  it 'should be part of athena.lib', ->
    expect(DocView).toBeDefined()


  it 'should look good', ->
    # create a div to safely append content to the page
    $safe = $('<div>').addClass('athena-lib-test').appendTo('body')

    doc = '''
    # Rendered Markdown Test

    ## Foo

    **Bar** *woooh!*

        Code?
        Code.

    '''

    view = new DocView
      doc: doc
      render: DocView.renderMarkdown
    view.render()
    $safe.append view.$el


  it 'should call given render function on render', ->
    spy = jasmine.createSpy()
    view = new DocView render: spy
    expect(spy).not.toHaveBeenCalled()
    view.render()
    expect(spy).toHaveBeenCalled()


  it 'should call given render function with @doc', ->
    spy = jasmine.createSpy()
    doc = 'Foo bar biz baz!'
    view = new DocView render: spy, doc: doc
    expect(view.doc()).toEqual doc
    view.render()
    expect(spy).toHaveBeenCalledWith doc
