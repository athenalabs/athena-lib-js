goog.provide 'athena.lib.util.spec'

goog.require 'athena.lib.util'
goog.require 'athena.lib.test.util'

util = athena.lib.util;

expectDerives = (a, b) -> expect(util.derives a, b).toBe true
expectDerivesNot = (a, b) -> expect(util.derives a, b).toBe false

describe 'athena.lib.util', ->
  it 'should be part of athena.lib', ->
    expect(athena.lib.util).toBeDefined()

  it 'should be an object', ->
    expect(_.isObject util).toBe true

  describe 'util.derives', ->
    it 'should be a function', ->
      expect(_.isFunction util.derives).toBe true

    class A
    class AB extends A
    class AC extends A
    class ABD extends AB
    class ACE extends AC
    class ACEF extends ACE
    class ACEFG extends ACEF

    it 'should correctly identify classes that derive', ->
      expectDerives AB, A
      expectDerives AC, A
      expectDerives ABD, A
      expectDerives ABD, AB
      expectDerives ACE, A
      expectDerives ACE, AC
      expectDerives ACEF, A
      expectDerives ACEF, AC
      expectDerives ACEF, ACE
      expectDerives ACEFG, A
      expectDerives ACEFG, AC
      expectDerives ACEFG, ACE
      expectDerives ACEFG, ACEF

    it 'should correctly identify classes that do not derive', ->
      expectDerivesNot A, A
      expectDerivesNot A, AB
      expectDerivesNot A, AC
      expectDerivesNot A, ABD
      expectDerivesNot AB, ABD
      expectDerivesNot A, ACE
      expectDerivesNot AC, ACE
      expectDerivesNot A, ACEF
      expectDerivesNot AC, ACEF
      expectDerivesNot ACE, ACEF
      expectDerivesNot A, ACEFG
      expectDerivesNot AC, ACEFG
      expectDerivesNot ACE, ACEFG
      expectDerivesNot ACEF, ACEFG
      expectDerivesNot ABD, AC
      expectDerivesNot ACE, AB
      expectDerivesNot ACEF, AB
      expectDerivesNot ACEF, ABD
      expectDerivesNot ACEFG, AB
      expectDerivesNot ACEFG, ABD
