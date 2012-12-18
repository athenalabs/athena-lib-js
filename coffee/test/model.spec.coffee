goog.provide 'athena.lib.specs.Model'

describe 'Model', ->
  Model = athena.lib.Model
  util = athena.lib.util

  # -- helper functions --

  testModelProperties = (model, properties) =>
    _.each properties, (property) =>
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

  describe 'Model properties', ->

    describe 'Model::addProperty', ->

      it 'should error out if property is not defined', ->
        m = new Model
        expect(-> m.property()).toThrow()

      it 'should error out if property is not a string', ->
        m = new Model
        expect(-> m.property()).toThrow()
        expect(-> m.property [1, 2, 3]).toThrow()
        expect(-> m.property title:1).toThrow()
        expect(-> m.property 432141).toThrow()

      it 'should create a property function', ->
        m = new Model
        m.addProperty 'duration'
        expect(_.isFunction m.duration).toBe true

      it 'should create a property function that gets the value', ->
        m = new Model duration: 100
        m.addProperty 'duration'
        expect(m.duration()).toBe 100
        expect(m.get 'duration').toBe 100

        m.set 'duration', 200
        expect(m.duration()).toBe 200
        expect(m.get 'duration').toBe 200

      it 'should create a property function that sets the value', ->
        m = new Model
        m.addProperty 'duration'
        expect(m.duration()).not.toBeDefined()
        expect(m.get 'duration').not.toBeDefined()

        m.duration(100)
        expect(m.duration()).toBe 100
        expect(m.get 'duration').toBe 100

      it 'should support defining a default value', ->
        m = new Model
        expect(-> m.duration()).toThrow()
        expect(m.get 'duration').not.toBeDefined()

        m.addProperty 'duration', 100
        expect(m.duration()).toBe 100
        expect(m.get 'duration').toBe 100

      it 'should not override existing values with default value', ->
        m = new Model duration: 200
        expect(-> m.duration()).toThrow()
        expect(m.get 'duration').toBe 200

        m.addProperty 'duration', 100
        expect(m.duration()).toBe 200
        expect(m.get 'duration').toBe 200

    describe 'Model::addProperties', ->

      it 'should error out if properties is not a map or string array', ->
        m = new Model
        expect(-> m.addProperties()).toThrow()
        expect(-> m.addProperties [1, 2, 3]).toThrow()
        expect(-> m.addProperties 'title').toThrow()
        expect(-> m.addProperties 432141).toThrow()
        expect(-> m.addProperties ['1', '2', '3']).not.toThrow()

      it 'should call addProperty with each key-value pair', ->
        m = new Model
        spy = spyOn(m, 'addProperty').andCallThrough()
        m.addProperties
          duration:100
          title: ''
        expect(spy).toHaveBeenCalled()
        expect(spy.callCount).toBe 2
        expect(typeof m.duration).toBe 'function'
        expect(typeof m.title).toBe 'function'


    describe 'Model::properties', ->

      it 'should be a function', ->
        expect(typeof Model::properties).toBe 'function'

      it 'should return a map', ->
        m = new Model
        expect(typeof m.properties()).toBe 'object'

      it 'should support defining properties at the class level', ->

        class Piece extends Model
          properties: =>
            genre: 'classical'

        m = new Piece
        expect(typeof m.genre).toBe 'function'
        expect(m.genre()).toBe 'classical'
        expect(m.get 'genre').toBe 'classical'
        expect(m.genre('dubstep')).toBe 'dubstep'
        expect(m.get 'genre').toBe 'dubstep'

    it 'should support properties', ->
      m = new Model
      m.addProperty 'genre'
      m.addProperties {composer: 'Mozart', piece: 'Figaro'}
      m.addProperties {location: 'Vienna'}
      m.addProperty 'duration'
      m.addProperty 'year'

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
