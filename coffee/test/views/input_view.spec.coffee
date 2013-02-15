goog.provide 'athena.lib.specs.InputView'
goog.require 'athena.lib.InputView'
goog.require 'athena.lib.util.keys'

describe 'athena.lib.InputView', ->
  InputView = athena.lib.InputView
  keys = athena.lib.util.keys


  it 'should be part of athena.lib', ->
    expect(InputView).toBeDefined()


  describeView = athena.lib.util.test.describeView
  describeView InputView, athena.lib.View, ->

    it 'should have tagName input', ->
      expect(InputView::tagName).toBe 'input'

    it 'should look good and work well', ->
      # create a div to safely append content to the page
      $safe = $('<div>').addClass('athena-lib-test').appendTo('body')

      types = ['text', 'password', 'radio', 'checkbox']
      views = _.map types, (type) ->
        view = new InputView type: type
        view.render()
        view.$el.css('margin', '20px').css('display', 'block')
        $safe.append view.$el
        view

      views[0].$el.attr 'placeholder',
        'what is the answer to life, the universe, and everything?'

      views[0].$el.css 'width', '400px'

      views[0].validationErrors = (value) ->
        unless value == '42'
          console.log 'nope'
          return ['nope']

        console.log 'yep'
        []


    test.describeDefaults InputView,
      type: 'text'
      placeholder: ''
      validateOnBlur: true
      blurOnEnter: true
      saveOnBlur: false
      save: undefined

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

    it 'should be a getter/setter (of $el.val)', ->
      view = new InputView
      _.each ['foo', 'bar', 'baz', '{}', '[1, 2, 3]'], (val) ->
        expect(view.value()).toBe view.$el.val()
        expect(view.value(val)).toEqual val
        expect(view.value()).toEqual val
        expect(view.value()).toEqual view.$el.val()


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
      expect(typeof InputView::validate).toBe 'function'

    it 'should return a boolean condition', ->
      expect(_.isBoolean new InputView().validate()).toBe true

    it 'should return whether validationErrors is empty', ->
      view = new InputView
      errors = [(-> []), (-> ['Not Empty']), (-> ['Def', 'Not', 'Empty'])]
      _.each errors, (validationErrors) ->
        view.validationErrors = validationErrors
        expect(view.validate()).toEqual _.isEmpty validationErrors()

  describe 'InputView::events', ->

    describe 'InputView::onBlur', ->

      it 'should call InputView::onBlur when the element blurs', ->
        view = new InputView
        spy = spyOn view, 'onBlur'
        view.delegateEvents()
        view.$el.trigger 'blur'
        expect(spy).toHaveBeenCalled()

      it 'should call InputView::validate if options.validateOnBlur', ->
        view = new InputView validateOnBlur: true
        spy = spyOn view, 'validate'
        view.$el.trigger 'blur'
        expect(spy).toHaveBeenCalled()

      it 'should call InputView::validate iff options.validateOnBlur', ->
        view = new InputView validateOnBlur: false
        spy = spyOn view, 'validate'
        view.$el.trigger 'blur'
        expect(spy).not.toHaveBeenCalled()

      it 'should call InputView::options.save if options.saveOnBlur', ->
        options = saveOnBlur: true, save: jasmine.createSpy()
        view = new InputView options
        view.$el.trigger 'blur'
        expect(options.save).toHaveBeenCalled()

      it 'should call InputView::options.save iff options.saveOnBlur', ->
        options = saveOnBlur: false, save: jasmine.createSpy()
        view = new InputView options
        view.$el.trigger 'blur'
        expect(options.save).not.toHaveBeenCalled()

      it 'should call InputView::options.save with value', ->
        options = saveOnBlur: true, save: jasmine.createSpy()
        view = new InputView options
        view.$el.trigger 'blur'
        expect(options.save.argsForCall[0][0]).toBe view.value()

      it 'should trigger Input:Save:Success if options.save succeeds', ->
        view = new InputView
          saveOnBlur: true
          save: (value, options) -> options.success value

        spy1 = new test.EventSpy view, 'Input:Save:Success'
        spy2 = new test.EventSpy view, 'Input:Save:Error'
        view.$el.trigger 'blur'
        expect(spy1.triggered).toBe true
        expect(spy2.triggered).toBe false
        expect(spy1.arguments[0]).toEqual [view, view.value()]

      it 'should trigger Input:Save:Error if options.save errors', ->
        error = 'Error: error!'
        view = new InputView
          saveOnBlur: true
          save: (value, options) -> options.error error

        spy1 = new test.EventSpy view, 'Input:Save:Success'
        spy2 = new test.EventSpy view, 'Input:Save:Error'
        view.$el.trigger 'blur'
        expect(spy1.triggered).toBe false
        expect(spy2.triggered).toBe true
        expect(spy2.arguments[0]).toEqual [view, error]


    describe 'InputView::onKeyup', ->

      it 'should call InputView::onKeyup when keyup happens on element', ->
        view = new InputView
        spy = spyOn view, 'onKeyup'
        view.delegateEvents()
        view.$el.trigger 'keyup'
        expect(spy).toHaveBeenCalled()


    describe 'InputView::onEnter', ->
      keyupEnter = $.Event 'keyup'
      keyupEnter.keyCode = keys.ENTER

      it 'should call InputView::onEnter if keyup event.keyCode is ENTER', ->
        view = new InputView
        spy = spyOn view, 'onEnter'
        view.$el.trigger keyupEnter
        expect(spy).toHaveBeenCalled()

      it 'should trigger blur if options.blurOnEnter', ->
        view = new InputView blurOnEnter: true
        spy = spyOn view, 'onBlur'
        view.delegateEvents()
        view.$el.trigger keyupEnter
        expect(spy).toHaveBeenCalled()

      it 'should trigger blur iff options.blurOnEnter', ->
        view = new InputView blurOnEnter: false
        spy = spyOn view, 'onBlur'
        view.delegateEvents()
        view.$el.trigger keyupEnter
        expect(spy).not.toHaveBeenCalled()
