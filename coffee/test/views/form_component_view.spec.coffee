goog.provide 'athena.lib.specs.FormComponentView'
goog.require 'athena.lib.FormComponentView'

describe 'athena.lib.FormComponentView', ->
  FormComponentView = athena.lib.FormComponentView
  test = athena.lib.util.test

  it 'should be part of athena.lib', ->
    expect(FormComponentView).toBeDefined()

  test.describeView FormComponentView, athena.lib.View, ->

    it 'should have a template function', ->
      expect(typeof FormComponentView::template).toBe 'function'

    it 'should look good and work well', ->
      # create a div to safely append content to the page
      $safe = $('<form>').addClass('form-horizontal').appendTo('body')

      fields = [
        {label: 'Username', type: 'text', helpInline: 'a-z 0-9 - _'},
        {label: 'Password', type: 'password', helpInline: 'safe, please.'},
        {label: 'Password', type: 'password', helpInline: 'say it again!'},
        {label: 'Email', type: 'text', helpInline: 'valid email only.'},
      ]

      views = _.map fields, (options) ->
        common = saveOnBlur: true, save: ->
        view = new FormComponentView _.extend common, options
        view.render()
        $safe.append view.$el
        view

      views[0].inputView.validationErrors = (value) ->
        unless value.match /^[a-z0-9-_]+$/i
          return ['a-z 0-9 - _ only']
        []

      views[1].inputView.validationErrors = (value) ->
        unless value.length > 9000
          return ['safe, please! make it longer!']
        []

      views[2].validationErrors = (value) ->
        unless value == views[1].inputView.value()
          return ['passwords don\'t match']
        []

      views[3].validationErrors = (value) ->
        if value.match /@(yahoo|aol|hotmail).com$/i
          return ['really? come on, it is 2012']
        []

    test.describeDefaults FormComponentView,
      inputView: undefined
      noValidation: false
      helpInline: ''
      helpBlock: ''
      label: ''



  test.describeSubview {
    View: FormComponentView
    subviewAttr: 'inputView'
    Subview: athena.lib.InputView
    checkDOM: (child, parent) -> child.parentNode.parentNode is parent
  }, ->

    it 'should call renderErrors on `Input:Save:Error`', ->
      view = new FormComponentView
      spyOn view, 'renderErrors'
      view.inputView.trigger 'Input:Save:Error', view.inputView, 'Error!!'
      expect(view.renderErrors).toHaveBeenCalled()

    it 'should call renderHelpMessage on `Input:Save:Success`', ->
      view = new FormComponentView
      spyOn view, 'renderHelpMessage'
      view.inputView.trigger 'Input:Save:Success', view.inputView, 'Foo'
      expect(view.renderHelpMessage).toHaveBeenCalled()

    it 'should call renderHelp after 2000 ms on `Input:Save:Success`', ->
      view = new FormComponentView
      spyOn view, 'renderHelp'
      view.inputView.trigger 'Input:Save:Success', view.inputView, 'Foo'
      expect(view.renderHelp.callCount).toBe 1
      waits 1900
      runs -> expect(view.renderHelp.callCount).toBe 1
      waits 200
      runs -> expect(view.renderHelp.callCount).toBe 2


  describe 'FormComponentView::value', ->

    it 'should be a function', ->
      expect(typeof FormComponentView::value).toBe 'function'

    it 'should be a getter/setter (of @inputView.value)', ->
      view = new FormComponentView
      _.each ['foo', 'bar', 'baz', '{}', '[1, 2, 3]'], (val) ->
        expect(view.value()).toBe view.inputView.value()
        expect(view.value(val)).toEqual view.inputView.value()
        expect(view.value()).toEqual val
        expect(view.value()).toEqual view.inputView.value()


  describe 'FormComponentView::validationErrors', ->

    it 'should be a function', ->
      expect(typeof FormComponentView::validationErrors).toBe 'function'

    it 'should return an array of errors', ->
      expect(_.isArray new FormComponentView().validationErrors()).toBe true

    it 'should be overridable', ->
      view = new FormComponentView
      expect(-> view.validationErrors()).not.toThrow()
      expect(_.isArray view.validationErrors()).toBe true

      view.validationErrors = (val) -> ['error!']
      expect(-> view.validationErrors()).not.toThrow()
      expect(_.isArray view.validationErrors()).toBe true
      expect(view.validationErrors()).toEqual ['error!']


  describe 'FormComponentView::validate', ->

    it 'should be a function', ->
      expect(typeof FormComponentView::validate).toBe 'function'

    it 'should return a boolean condition', ->
      expect(_.isBoolean new FormComponentView().validate()).toBe true

    it 'should return whether validationErrors is empty', ->
      view = new FormComponentView
      errors = [(-> []), (-> ['Not Empty']), (-> ['Def', 'Not', 'Empty'])]
      _.each errors, (validationErrors) ->
        view.validationErrors = validationErrors
        expect(view.validate()).toEqual _.isEmpty validationErrors()

    it 'should return true if options.noValidation', ->
      view = new FormComponentView noValidation: true
      errors = [(-> []), (-> ['Not Empty']), (-> ['Def', 'Not', 'Empty'])]
      _.each errors, (validationErrors) ->
        view.validationErrors = validationErrors
        expect(view.validate()).toBe true
