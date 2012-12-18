goog.provide 'athena.lib.Model'

# top level model for athena.lib
class athena.lib.Model extends Backbone.Model

  initialize: =>
    super
    @properties _.keys @attributes


  # Defines a property on this model instance.
  # The parameter `property` is expected to be of type string.
  # For instance:
  #
  #    m.property 'title'
  #
  # After the above:
  #
  #    m.title()              is equivalent to         m.get 'title'
  #
  # And,
  #
  #    m.title 'Title'        is equivalent to         m.set 'title', 'Title'
  #
  property: (property) =>
    unless property?
      throw new Error "Expected `property` parameter to be defined."

    unless _.isString property
      throw new Error "Expected `property` to be of type string."

    @[property] = (value) =>
      if value?
        @set property, value
      @get property


  # Defines a property for each string name in `propertyArray`
  # Calls @property (above) on each element of the array.
  properties: (propertyArray) =>
    if not propertyArray?
      throw new Error "Expected `propertyArray` parameter to be defined."

    unless _.isArray propertyArray
      throw new Error "Expected `propertyArray` parameter to be of type Array."

    _.each propertyArray, (property) => @property property


  # ensure clone is deeply-copied, as acorn data is a multilevel object
  # this approach to deep-copy is ok because all our data should be
  # JSON serializable.
  #
  # See https://github.com/documentcloud/underscore/issues/162 as to why
  # underscore does not implement deep copy.
  clone: => return new @constructor @toJSON()

  toJSON: => return JSON.parse JSON.stringify @attributes

  toJSONString: => return JSON.stringify @toJSON()
