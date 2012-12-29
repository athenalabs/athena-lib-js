goog.provide 'athena.lib.specs.Model'

describe 'Model', ->
  Model = athena.lib.Model
  util = athena.lib.util

  it 'should be a part of athena.lib', ->
    expect(Model).toBeDefined()

  it 'should derive from Backbone.Model', ->
    expect(util.derives Model, Backbone.Model).toBe true

  describe 'Model::property', ->

    it 'should be a static function', ->
      expect(Model.property).toEqual jasmine.any Function

    it 'should error out unless the first argument is a string', ->
      expect(-> Model.property()).toThrow()
      expect(-> Model.property {}).toThrow()
      expect(-> Model.property {}, 'cheese').toThrow()
      expect(-> Model.property turn: 'along').toThrow()
      expect(-> Model.property []).toThrow()
      expect(-> Model.property [], 'bow').toThrow()
      expect(-> Model.property ['out', 'up']).toThrow()
      expect(-> Model.property 87).toThrow()
      expect(-> Model.property 87, 'shoe').toThrow()
      expect(-> Model.property '').not.toThrow()
      expect(-> Model.property '87', []).not.toThrow()
      expect(-> Model.property 'draw', {}).not.toThrow()

    it 'should return a function', ->
      expect(Model.property 'name').toEqual jasmine.any Function

    it 'should return a function that calls @get', ->
      class User extends Model
        name: @property 'name'

      user = new User()
      spyOn user, 'get'

      user.name()
      expect(user.get).toHaveBeenCalled()

    it 'should return a function that calls @set', ->
      class User extends Model
        name: @property 'name'

      user = new User()
      spyOn user, 'set'

      user.name 'park jae-sang'
      expect(user.set).toHaveBeenCalled()

    it 'should return a function that gets an attribute value', ->
      class User extends Model
        name: @property 'name'
        dreams: @property 'dreams'
        favoriteColor: @property 'favoriteColor'

      user = new User()

      user.set 'name', 'park jae-sang'
      expect(user.name()).toBe 'park jae-sang'
      user.set 'name', 'psy'
      expect(user.name()).toBe 'psy'

      user.set 'dreams', ['horseback riding']
      expect(user.dreams()).toEqual ['horseback riding']
      user.set 'dreams', ['horseback riding', 'day tripping']
      expect(user.dreams()).toEqual ['horseback riding', 'day tripping']

      user.set 'favoriteColor', ''
      expect(user.favoriteColor()).toBe ''
      user.set 'favoriteColor', 'yellow'
      expect(user.favoriteColor()).toBe 'yellow'

    it 'should return a function that sets an attribute value', ->
      class User extends Model
        name: @property 'name'
        dreams: @property 'dreams'
        favoriteColor: @property 'favoriteColor'

      user = new User()

      expect(user.name 'park jae-sang').toBe 'park jae-sang'
      expect(user.get 'name').toBe 'park jae-sang'
      expect(user.name 'psy').toBe 'psy'
      expect(user.get 'name').toBe 'psy'

      expect(user.dreams ['horseback riding']).toEqual ['horseback riding']
      expect(user.get 'dreams').toEqual ['horseback riding']
      expect(user.dreams ['horseback riding', 'day tripping'])
          .toEqual ['horseback riding', 'day tripping']
      expect(user.get 'dreams').toEqual ['horseback riding', 'day tripping']

      expect(user.favoriteColor '').toBe ''
      expect(user.get 'favoriteColor').toBe ''
      expect(user.favoriteColor 'yellow').toBe 'yellow'
      expect(user.get 'favoriteColor').toBe 'yellow'

    it 'should return a function that works with various value types', ->
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

      expect(user.favoriteColor {}).toEqual {}
      expect(user.favoriteColor()).toEqual {}
      expect(user.favoriteColor {forWomanPantSuits: 'yellow'})
          .toEqual {forWomanPantSuits: 'yellow'}
      expect(user.favoriteColor()).toEqual {forWomanPantSuits: 'yellow'}

    it 'should enable property name and attribute name to be different', ->
      class User extends Model
        moniker: @property 'name'
        dreams: @property 'hobbies'
        bestHue: @property 'favoriteColor'

      user = new User()

      expect(user.moniker 'park jae-sang').toBe 'park jae-sang'
      expect(user.get 'name').toBe 'park jae-sang'
      user.set 'name', 'psy'
      expect(user.moniker()).toBe 'psy'

      expect(user.dreams ['horseback riding']).toEqual ['horseback riding']
      expect(user.get 'hobbies').toEqual ['horseback riding']
      user.set 'hobbies', ['horseback riding', 'day tripping']
      expect(user.dreams()).toEqual ['horseback riding', 'day tripping']

      expect(user.bestHue '').toBe ''
      expect(user.get 'favoriteColor').toBe ''
      user.set 'favoriteColor', 'yellow'
      expect(user.bestHue()).toBe 'yellow'

    it 'should return a read-only getter when options.setter is false', ->
      class User extends Model
        height: @property('height', setter: false)
        birthday: @property('birthday', setter: false)
        eyeColor: @property('eyeColor', setter: false)

      user = new User()

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

    it 'should return a function whose default value can be set with
        options.default', ->
      class Knight extends Model
        color: @property('color', default: 'blue')

      galahad = new Knight()
      expect(galahad.get 'color').toBe undefined
      expect(galahad.color()).toBe 'blue'
      galahad.color('yellow')
      expect(galahad.get 'color').toBe 'yellow'
      expect(galahad.color()).toBe 'yellow'

    it 'should still use options.default when options.setter is false', ->
      toSeekTheGrail = 'To seek the Holy Grail'
      toAttackTheFrench = 'To attack the French'

      class King extends Model
        quest: @property('quest', {setter: false, default: toSeekTheGrail})

      arthur = new King()
      expect(arthur.get 'quest').toBe undefined
      expect(arthur.quest()).toBe toSeekTheGrail
      arthur.quest(toAttackTheFrench)
      expect(arthur.get 'quest').toBe undefined
      expect(arthur.quest()).toBe toSeekTheGrail
      arthur.set {quest: toAttackTheFrench}
      expect(arthur.get 'quest').toBe toAttackTheFrench
      expect(arthur.quest()).toBe toAttackTheFrench


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
