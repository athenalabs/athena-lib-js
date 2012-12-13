goog.provide 'athena.lib.util.test.spec'

goog.require 'athena.lib.util.test'

test = athena.lib.util.test

describe 'athena.lib.util.test', ->
  it 'should be defined', ->
    expect(test).toBeDefined()

  describe 'test.throwsExceptionWithString', ->
    throwyFn = (param) -> throw Error('Hai! 42')
    fn = (param) ->

    it 'throws an exception when it should', ->
      expect(test.throwsExceptionWithString '42', throwyFn).toBe true
      expect(test.throwsExceptionWithString '42', throwyFn, []).toBe true
      expect(test.throwsExceptionWithString '42', throwyFn, [ 'ey' ]).toBe true

    it 'doesn\'t throw an exception when it shouldn\'t', ->
      expect(test.throwsExceptionWithString '45', throwyFn).toBe false
      expect(test.throwsExceptionWithString '45', throwyFn, []).toBe false
      expect(test.throwsExceptionWithString '45', throwyFn, [ 'ey' ]).toBe false

      expect(test.throwsExceptionWithString '42', fn).toBe false
      expect(test.throwsExceptionWithString '42', fn, []).toBe false
      expect(test.throwsExceptionWithString '42', fn, [ 'ey' ]).toBe false
