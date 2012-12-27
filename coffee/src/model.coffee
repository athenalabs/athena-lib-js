goog.provide 'athena.lib.Model'

# top level model for athena.lib
class athena.lib.Model extends Backbone.Model

  # static method for adding property manager methods
  @property: (property, setter = true) ->
    (value) ->
      if setter and value?
        @set property, value
      @get property

  # ensure clone is deeply-copied, as acorn data is a multilevel object
  # this approach to deep-copy is ok because all our data should be
  # JSON serializable.
  #
  # See https://github.com/documentcloud/underscore/issues/162 as to why
  # underscore does not implement deep copy.
  clone: => return new @constructor @toJSON()

  toJSON: => return JSON.parse JSON.stringify @attributes

  toJSONString: => return JSON.stringify @toJSON()
