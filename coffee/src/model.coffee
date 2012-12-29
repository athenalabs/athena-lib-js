goog.provide 'athena.lib.Model'

# top level model for athena.lib
class athena.lib.Model extends Backbone.Model

  # static method for adding property manager methods
  @property: (property, options={}) ->
    unless _.isString property
      throw new Error 'property method: first argument must be a string'
    unless athena.lib.util.isStrictObject options
      options = {}

    (value) ->
      if options.setter isnt false and value?
        @set property, value
      @get(property) ? options.default

  # ensure clone is deeply-copied, as acorn data is a multilevel object
  # this approach to deep-copy is ok because all our data should be
  # JSON serializable.
  #
  # See https://github.com/documentcloud/underscore/issues/162 as to why
  # underscore does not implement deep copy.
  clone: => return new @constructor @toJSON()

  toJSON: => return JSON.parse JSON.stringify @attributes

  toJSONString: => return JSON.stringify @toJSON()
