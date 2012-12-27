goog.provide 'athena.lib.specs.Model'

describe 'Model', ->
  Model = athena.lib.Model
  util = athena.lib.util

  it 'should be a part of athena.lib', ->
    expect(Model).toBeDefined()

  it 'should derive from Backbone.Model', ->
    expect(util.derives Model, Backbone.Model).toBe true

  describe 'Model::property', ->

    it 'should create property get/setters by default', ->
      class User extends Model
        name: @property 'name'
        dreams: @property 'dreams'
        favoriteColor: @property 'favoriteColor'

      user = new User()

      expect(user.name 'park jae-sang').toBe 'park jae-sang'
      expect(user.name()).toBe 'park jae-sang'
      expect(user.name 'psy').toBe 'psy'
      expect(user.name()).toBe 'psy'

      expect(user.dreams ['horseback riding']).toEqual ['horseback riding']
      expect(user.dreams()).toEqual ['horseback riding']
      expect(user.dreams ['horseback riding', 'day tripping'])
          .toEqual ['horseback riding', 'day tripping']
      expect(user.dreams()).toEqual ['horseback riding', 'day tripping']

      expect(user.favoriteColor '').toBe ''
      expect(user.favoriteColor()).toBe ''
      expect(user.favoriteColor 'yellow').toBe 'yellow'
      expect(user.favoriteColor()).toBe 'yellow'

    it 'should offer read-only getters when passed a falsy parameter', ->
      class User extends Model
        height: @property('height', false)
        birthday: @property('birthday', false)
        eyeColor: @property('eyeColor', false)

      user = new User()
      console.log user

      expect(user.height '2.0 meters').toBe undefined
      user.set {height: '1.7 meters'}
      expect(user.height()).toBe '1.7 meters'
      expect(user.height '2.0 meters').toBe '1.7 meters'

      expect(user.birthday '06/24/1993').toBe undefined
      user.set {birthday: '12/31/1977'}
      expect(user.birthday()).toBe '12/31/1977'
      expect(user.birthday '06/24/1993').toBe '12/31/1977'

      expect(user.eyeColor 'red').toBe undefined
      user.set {eyeColor: 'brown'}
      expect(user.eyeColor()).toBe 'brown'
      expect(user.eyeColor 'red').toBe 'brown'


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
