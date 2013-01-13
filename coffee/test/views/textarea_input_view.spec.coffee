goog.provide 'athena.lib.specs.TextareaInputView'
goog.require 'athena.lib.TextareaInputView'

describe 'athena.lib.TextareaInputView', ->
  TextareaInputView = athena.lib.TextareaInputView


  it 'should be part of athena.lib', ->
    expect(TextareaInputView).toBeDefined()


  describeView = athena.lib.util.test.describeView
  describeView TextareaInputView, athena.lib.View, ->

    it 'should have tagName textarea', ->
      expect(TextareaInputView::tagName).toBe 'textarea'

    it 'should look good and work well', ->
      # create a div to safely append content to the page
      $safe = $('<div>').addClass('athena-lib-test').appendTo('body')

      types = ['text', 'password', 'radio', 'checkbox']
      views = _.map types, (type) ->
        view = new TextareaInputView type: type
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


    test.describeDefaults TextareaInputView,
      rows: 3

    describe 'TextareaInputView::elAttributes', ->

      it 'should have a placeholder (from @options)', ->
        views = [
          new TextareaInputView
          new TextareaInputView placeholder: 'foo'
        ]
        _.each views, (view) ->
          expect(view.elAttributes().placeholder).toBe view.options.placeholder

      it 'should have a row (from @options)', ->
        views = [
          new TextareaInputView
          new TextareaInputView rows: 5
        ]
        _.each views, (view) ->
          expect(view.elAttributes().rows).toBe view.options.rows

      it 'should have a value (from @value)', ->
        _.each [{}, {value: 'foo'}, {value: 'bar'}], (attrs) ->
          view = new TextareaInputView model: new Backbone.Model attrs
          expect(view.elAttributes().value).toBe view.value()
