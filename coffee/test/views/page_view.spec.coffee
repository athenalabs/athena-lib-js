goog.provide 'athena.lib.specs.PageView'
goog.require 'athena.lib.util.test'
goog.require 'athena.lib.PageView'

describe 'PageView', ->
  PageView = athena.lib.PageView
  util = athena.lib.util

  it 'should be part of athena.lib', ->
    expect(PageView).toBeDefined()

  describeView = athena.lib.util.test.describeView
  describeView PageView, athena.lib.View
