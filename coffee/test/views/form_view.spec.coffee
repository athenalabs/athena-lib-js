goog.provide 'athena.lib.specs.FormView'
goog.require 'athena.lib.FormView'

describe 'athena.lib.FormView', ->
  FormView = athena.lib.FormView
  FormComponentView = athena.lib.FormComponentView
  test = athena.lib.util.test

  it 'should be part of athena.lib', ->
    expect(FormView).toBeDefined()

  test.describeView FormView, athena.lib.View, ->

    it 'should have tagName `form`', ->
      expect(FormView::tagName).toBe 'form'

    it 'should look good and work well', ->
      # create a div to safely append content to the page
      $safe = $('<form>').addClass('form-horizontal').appendTo('body')

      fields = [
        {placeholder: 'What is your name?'},
        {placeholder: 'What is you quest?'},
        {placeholder: 'What is the capital of Assyria?'},
      ]

      view = new FormView

      _.map fields, (options) ->
        view.addComponentView new FormComponentView options

      view.render()
      $safe.append view.$el
      view

      view.componentViews[1].validationErrors = (value) ->
        unless value.match /grail/i
          return ['GO AWAY']
        []

      view.componentViews[2].inputView.validationErrors = (value) ->
        unless value.toLowerCase() is 'assur'
          return ['WRONG']
        []

    test.describeDefaults FormView,
      noValidation: false


    describe 'FormView::elAttributes', ->

      it 'should have onsubmit (\`return false;\')', ->
        attrs = new FormView().elAttributes()
        expect(attrs.onsubmit).toBe 'return false;'


  describe 'FormView::componentViews', ->

    it 'should be an array', ->
      view = new FormView
      expect(_.isArray new FormView().componentViews).toBe true

    describe 'FormView::addComponentView', ->

      it 'should be a function', ->
        expect(typeof FormView::addComponentView).toBe 'function'

      it 'should push view to FormView::componentViews', ->
        view = new FormView
        for i in _.range(5)
          cmp = new FormComponentView
          view.addComponentView cmp
          expect(_.last view.componentViews).toBe cmp
        expect(view.componentViews.length).toBe 5

      it 'should call FormView::renderComponentView if @rendering', ->
        view = new FormView
        cmp = new FormComponentView
        spy = spyOn view, 'renderComponentView'

        view.addComponentView cmp
        expect(spy).not.toHaveBeenCalledWith cmp

        view.render()
        view.addComponentView cmp
        expect(spy).toHaveBeenCalledWith cmp

      it 'should throw error unless view is instanceof FormComponentView', ->
        view = new FormView
        expect(-> view.addComponentView new FormComponentView).not.toThrow()
        expect(-> view.addComponentView new athena.lib.View).toThrow()


    describe 'FormView::renderComponentView', ->

      it 'should render and append given view to $el', ->
        view = new FormView
        cmp = new FormComponentView
        renderSpy = spyOn(cmp, 'render').andCallThrough()
        appendSpy = spyOn view.$el, 'append'

        view.render()
        expect(renderSpy).not.toHaveBeenCalled()
        expect(appendSpy).not.toHaveBeenCalledWith cmp

        view.renderComponentView cmp
        expect(renderSpy).toHaveBeenCalled()
        expect(appendSpy).toHaveBeenCalledWith cmp.el

      it 'should be called by render', ->
          view = new FormView
          cmp = new FormComponentView
          spy = spyOn view, 'renderComponentView'

          view.addComponentView cmp
          expect(spy).not.toHaveBeenCalled()

          view.render()
          expect(spy).toHaveBeenCalled()

      it 'should throw error unless view is instanceof FormComponentView', ->
        view = new FormView
        view.render()
        expect(-> view.renderComponentView new FormComponentView).not.toThrow()
        expect(-> view.renderComponentView new athena.lib.View).toThrow()


    describe 'FormView::getComponentView', ->

      it 'should return undefined when componentViews is empty', ->
        view = new FormView
        expect(_.isEmpty view.componentViews).toBe true
        expect(view.getComponentView 'some-id').toBe undefined

      it 'should return undefined when view-id is not there', ->
        view = new FormView
        view.addComponentView new FormComponentView
        view.addComponentView new FormComponentView
        view.addComponentView new FormComponentView
        expect(view.getComponentView 'some-id').toBe undefined

      it 'should return view when view-id is there', ->
        view = new FormView
        cmp = new FormComponentView id: 'foo'
        view.addComponentView new FormComponentView
        view.addComponentView new FormComponentView
        view.addComponentView cmp
        view.addComponentView new FormComponentView
        expect(view.getComponentView 'foo').toBe cmp

    describe 'FormView::values', ->

      it 'should return empty if there are no componentViews', ->
        view = new FormView
        expect(_.isEmpty view.values()).toBe true

      it 'should return the values of all componentViews', ->
        view = new FormView
        for i in _.range(5)
          cmp = new FormComponentView id: "cmpView#{i}"
          cmp.value(i)
          expect(cmp.value()).toBe "#{i}"
          view.addComponentView cmp

        values = view.values()
        expect(values.cmpView0).toBe '0'
        expect(values.cmpView1).toBe '1'
        expect(values.cmpView2).toBe '2'
        expect(values.cmpView3).toBe '3'
        expect(values.cmpView4).toBe '4'
        expect(_.size values).toBe 5


  describe 'FormView::validate', ->

    it 'should be a function', ->
      expect(typeof FormView::validate).toBe 'function'

    it 'should return a boolean condition', ->
      expect(_.isBoolean new FormView().validate()).toBe true

    it 'should succeed if there are no componentViews', ->
      expect(new FormView().validate()).toBe true

    it 'should succeed if all componentViews validate true', ->
      view = new FormView
      for i in _.range(5)
        cmp = new FormComponentView
        view.addComponentView cmp
        expect(cmp.validate()).toBe true
      expect(view.validate()).toBe true

    it 'should fail if any componentViews validate false', ->
      view = new FormView
      for i in _.range(5)
        cmp = new FormComponentView
        view.addComponentView cmp
        expect(cmp.validate()).toBe true
      expect(view.validate()).toBe true

      cmp = new FormComponentView
      cmp.validationErrors = -> return ['fail!']
      view.addComponentView cmp

      expect(view.validate()).toBe false

    it 'should return true if options.noValidation', ->
      view = new FormView noValidation: false
      cmp = new FormComponentView
      cmp.validationErrors = -> return ['fail!']
      view.addComponentView cmp

      expect(view.validate()).toBe false

      view = new FormView noValidation: true
      cmp = new FormComponentView
      cmp.validationErrors = -> return ['fail!']
      view.addComponentView cmp

      expect(view.validate()).toBe true


  describe 'FormView::submit', ->

    it 'should be a function', ->
      expect(typeof FormView::submit).toBe 'function'

    it 'should return false if validate fails', ->
      view = new FormView
      view.validate = -> false
      expect(view.submit()).toBe false

    it 'should return true if validate succeeds', ->
      view = new FormView
      view.validate = -> true
      expect(view.submit()).toBe true

    it 'should trigger "FormView:Submit:Error" if validate fails', ->
      view = new FormView
      spy1 = new test.EventSpy view, 'FormView:Submit:Error'
      spy2 = new test.EventSpy view, 'FormView:Submit:Success'
      view.validate = -> false
      view.submit()
      expect(spy1.triggered).toBe true
      expect(spy2.triggered).toBe false

    it 'should trigger "FormView:Submit:Success" if validate succeeds', ->
      view = new FormView
      spy1 = new test.EventSpy view, 'FormView:Submit:Error'
      spy2 = new test.EventSpy view, 'FormView:Submit:Success'
      view.validate = -> true
      view.submit()
      expect(spy1.triggered).toBe false
      expect(spy2.triggered).toBe true
