goog.provide 'athena.lib.Model'

# top level model for athena.lib
class athena.lib.Model extends Backbone.Model

  # Defines the properties to be initialized on this model. This function
  # should return a mapping of `property` to `defaultValue`. For example:
  #
  #
  #    title: 'Untitled',
  #    description:
  #    age: 0
  #
  # Initializes properties thus:
  #
  #    m.addProperty 'title', 'Untitled'
  #    m.addProperty 'description', undefined
  #    m.addProperty 'age', 0
  properties: => {}

  initialize: =>
    super
    @addProperties @properties()

  # Defines a property on this model instance.
  # The parameter `property` is expected to be of type string.
  # For instance:
  #
  #    m.addProperty 'title'
  #    m.addProperty 'age', 0
  #
  # After the above:
  #    m.title()              is equivalent to         m.get 'title'
  #
  # And,
  #    m.title 'Title'        is equivalent to         m.set 'title', 'Title'
  #
  # And age has an initial value of 0
  addProperty: (property, defaultValue) =>
    unless _.isString property
      throw new Error "Expected `property` parameter of type string."

    @[property] = (value) =>
      if value?
        @set property, value
      @get property

    if defaultValue? and not @[property]()?
      @[property] defaultValue


  # Defines a property for each string name in `properties`
  # Calls @addProperty (above) on each element of the dictionary.
  addProperties: (properties) =>
    unless _.isObject properties
      throw new Error "Expected `properties` parameter of type object."

    _.each properties, (value, property) => @addProperty property, value


  # ensure clone is deeply-copied, as acorn data is a multilevel object
  # this approach to deep-copy is ok because all our data should be
  # JSON serializable.
  #
  # See https://github.com/documentcloud/underscore/issues/162 as to why
  # underscore does not implement deep copy.
  clone: => return new @constructor @toJSON()

  toJSON: => return JSON.parse JSON.stringify @attributes

  toJSONString: => return JSON.stringify @toJSON()
