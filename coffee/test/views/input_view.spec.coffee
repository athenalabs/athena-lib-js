goog.provide 'athena.lib.specs.InputView'
goog.require 'athena.lib.InputView'

describe 'InputView', ->
  InputView = athena.lib.InputView


  it 'should be part of athena.lib', ->
    expect(InputView).toBeDefined()


  describeView = athena.lib.util.test.describeView
  describeView InputView, athena.lib.View, ->

    it 'should have tagName input', ->
      expect(InputView::tagName).toBe 'input'

    it 'should have option `type` (default: \'text\')', ->
      expect(new InputView().defaults().type).toBe 'text'

    it 'should have option `placeholder` (default: \'\')', ->
      expect(new InputView().defaults().placeholder).toBe ''

    it 'should look good', ->
      # create a div to safely append content to the page
      $safe = $('<div>').addClass('athena-lib-test').appendTo('body')

      types = ['text', 'password', 'radio', 'checkbox']
      _.each types, (type) ->
        view = new InputView type: type
        view.render()
        view.$el.css('margin', '20px').css('display', 'block')
        $safe.append view.$el

    describe 'InputView::elAttributes', ->

      it 'should have a placeholder (from @options)', ->
        _.each [new InputView, new InputView placeholder: 'foo'], (view) ->
          expect(view.elAttributes().placeholder).toBe view.options.placeholder

      it 'should have a type (from @options)', ->
        _.each [new InputView, new InputView type: 'password'], (view) ->
          expect(view.elAttributes().type).toBe view.options.type

      it 'should have a value (from @value)', ->
        _.each [{}, {value: 'foo'}, {value: 'bar'}], (attrs) ->
          view = new InputView model: new Backbone.Model attrs
          expect(view.elAttributes().value).toBe view.value()


  describe 'InputView::value', ->

    it 'should be a function', ->
      expect(typeof InputView::value).toBe 'function'

    it 'should be a getter/setter of model.value', ->
      view = new InputView
      _.each ['foo', 'bar', 'baz', {}, [1, 2, 3]], (val) ->
        expect(view.value()).toBe view.model.get 'value'
        expect(view.value(val)).toBe val
        expect(view.value()).toBe val
        expect(view.value()).toBe view.model.get 'value'


  describe 'InputView::validationErrors', ->

    it 'should be a function', ->
      expect(typeof InputView::validationErrors).toBe 'function'

    it 'should return an array of errors', ->
      expect(_.isArray new InputView().validationErrors()).toBe true

    it 'should be overridable', ->
      view = new InputView
      expect(-> view.validationErrors()).not.toThrow()
      expect(_.isArray view.validationErrors()).toBe true

      view.validationErrors = (val) -> ['error!']
      expect(-> view.validationErrors()).not.toThrow()
      expect(_.isArray view.validationErrors()).toBe true
      expect(view.validationErrors()).toEqual ['error!']


  describe 'InputView::validate', ->

    it 'should be a function', ->
      expect(typeof InputView::validationErrors).toBe 'function'

    it 'should return a boolean condition', ->
      expect(_.isBoolean new InputView().validate()).toBe true

    it 'should return whether validationErrors is empty', ->
      view = new InputView
      errors = [(-> []), (-> ['Not Empty']), (-> ['Def', 'Not', 'Empty'])]
      _.each errors, (validationErrors) ->
        view.validationErrors = validationErrors
        expect(view.validate()).toEqual _.isEmpty validationErrors()
