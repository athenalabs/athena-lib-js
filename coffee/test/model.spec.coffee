goog.provide 'athena.lib.specs.Model'

describe 'Model', ->
  Model = athena.lib.Model
  util = athena.lib.util

  # -- helper functions --

  testModelProperties = (model, propertyArray) =>
    _.each propertyArray, (property) =>
      existingValue = model.get property

      expect(_.isFunction model[property]).toBe true

      # before setting, property value should be existingValue
      expect(model[property]()).toBe existingValue
      expect(model.get property).toBe existingValue

      # modification of property
      expect(model[property](42)).toBe 42

      # access of property after modification
      expect(model[property]()).toBe 42

      # access via backbone interface
      expect(model.get property).toBe 42

      # modification via backbone interface
      model.set property, 2
      expect(model[property]()).toBe 2


  # -- tests --

  it 'should be a part of athena.lib', ->
    expect(Model).toBeDefined()

  it 'should derive from Backbone.Model', ->
    expect(util.derives Model, Backbone.Model).toBe true

  it 'should support addition explicit properties', ->
    m = new Model { 'genre': 'classical' }
    m.properties [ 'composer', 'piece' ]
    m.properties [ 'location' ]
    m.property 'duration'
    m.property 'year'

    properties = 'composer piece location duration year genre'.split ' '
    testModelProperties m, properties


  it 'should be clonable (with deep-copies)', ->
    deep = {'a': 5}
    m = new Model {shellid:'Shell', a: b: c: deep}
    expect(m.clone().attributes.a.b.c).toEqual deep
    expect(m.clone().attributes.a.b.c).not.toBe deep

    # ensure the same thing breaks on Backbone's non-deep copy
    b = new Backbone.Model {shellid:'Shell', a: b: c: deep}
    expect(b.clone().attributes.a.b.c).toEqual deep
    expect(b.clone().attributes.a.b.c).toBe deep

  it 'should have a toJSONString function', ->
    expect(typeof Model::toJSONString).toBe 'function'
    m = new Model {shellid:'Shell', a: b: c: {'a': 5}}
    s = m.toJSONString()
    expect(JSON.stringify m.attributes).toEqual s
