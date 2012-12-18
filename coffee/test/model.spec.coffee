goog.provide 'athena.lib.specs.Model'

describe 'Model', ->
  Model = athena.lib.Model
  util = athena.lib.util

  it 'should be a part of athena.lib', ->
    expect(Model).toBeDefined()

  it 'should derive from Backbone.Model', ->
    expect(util.derives Model, Backbone.Model).toBe true

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
