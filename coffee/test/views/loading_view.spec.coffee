goog.provide 'athena.lib.specs.LoadingView'
goog.require 'athena.lib.util.test'
goog.require 'athena.lib.LoadingView'

describe 'LoadingView', ->
  LoadingView = athena.lib.LoadingView
  test = athena.lib.util.test


  test.describeView LoadingView, athena.lib.View


  test.describeDefaults LoadingView,
    img: '//athena.ai/img/gray-a-logo.png'


  it 'should be part of athena.lib', ->
    expect(LoadingView).toBeDefined()


  it 'should look good', ->
    # create a div to safely append content to the page
    $safe = $('<div>').addClass('athena-lib-test').appendTo('body')

    view = new LoadingView
    $safe.append view.render().$el
    # view.renderLoading()
