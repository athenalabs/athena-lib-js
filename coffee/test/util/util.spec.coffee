goog.provide 'athena.lib.specs.util'

goog.require 'athena.lib.util'

util = athena.lib.util


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

    expectDerives = (a, b) -> expect(util.derives a, b).toBe true
    expectDerivesNot = (a, b) -> expect(util.derives a, b).toBe false

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

  describe 'util.isOrDerives', ->
    it 'should be a function', ->
      expect(_.isFunction util.isOrDerives).toBe true

    class A
    class AB extends A
    class AC extends A
    class ABD extends AB
    class ACE extends AC
    class ACEF extends ACE
    class ACEFG extends ACEF

    expectIsOrDerives = (a, b) -> expect(util.isOrDerives a, b).toBe true
    expectIsOrDerivesNot = (a, b) -> expect(util.isOrDerives a, b).toBe false

    it 'should correctly identify classes that derive', ->
      expectIsOrDerives A, A
      expectIsOrDerives AB, A
      expectIsOrDerives AC, A
      expectIsOrDerives ABD, A
      expectIsOrDerives ABD, AB
      expectIsOrDerives ACE, A
      expectIsOrDerives ACE, AC
      expectIsOrDerives ACEF, A
      expectIsOrDerives ACEF, AC
      expectIsOrDerives ACEF, ACE
      expectIsOrDerives ACEFG, A
      expectIsOrDerives ACEFG, AC
      expectIsOrDerives ACEFG, ACE
      expectIsOrDerives ACEFG, ACEF

    it 'should correctly identify classes that do not derive', ->
      expectIsOrDerivesNot A, AB
      expectIsOrDerivesNot A, AC
      expectIsOrDerivesNot A, ABD
      expectIsOrDerivesNot AB, ABD
      expectIsOrDerivesNot A, ACE
      expectIsOrDerivesNot AC, ACE
      expectIsOrDerivesNot A, ACEF
      expectIsOrDerivesNot AC, ACEF
      expectIsOrDerivesNot ACE, ACEF
      expectIsOrDerivesNot A, ACEFG
      expectIsOrDerivesNot AC, ACEFG
      expectIsOrDerivesNot ACE, ACEFG
      expectIsOrDerivesNot ACEF, ACEFG
      expectIsOrDerivesNot ABD, AC
      expectIsOrDerivesNot ACE, AB
      expectIsOrDerivesNot ACEF, AB
      expectIsOrDerivesNot ACEF, ABD
      expectIsOrDerivesNot ACEFG, AB
      expectIsOrDerivesNot ACEFG, ABD
