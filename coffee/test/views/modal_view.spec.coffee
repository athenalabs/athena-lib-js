goog.provide 'athena.lib.specs.ModalView'
goog.require 'athena.lib.ModalView'
goog.require 'athena.lib.util.keys'
goog.require 'athena.lib.util.test'


describe 'athena.lib.ModalView', ->
  ModalView = athena.lib.ModalView
  keys = athena.lib.util.keys

  disable = true
  message = 'Breaks on PhantomJS'
  [cit, cdescribe] = athena.lib.util.test.conditionalDisablers disable, message
  
  # handles for before and after each blocks
  $div = undefined
  modalView = undefined

  # disable transitions to avoid asynchronicity
  disableTransitionOptions = ->
    fadeIn: false
    fadeOut: false

  # test that a modal is or is not shown
  expectModalShownStatus = (modal, shown) ->
    display = modal.$el.prop('style').display
    if shown
      expect(!!display and display != 'none').toBe true
    else
      expect(modal.$el.hasClass 'hide').toBe true
      expect(!!display and display != 'none').toBe false

  # wrap a function so it only executes the first time it is called. useful for
  # spies to avoid asserting expectations about afterEach behavior
  runOnce = (fn) ->
    ran = false
    ->
      fn arguments... unless ran
      ran = true

  # create an in-DOM div
  beforeEach ->
    $div = $('<div>').addClass('athena-lib-test').appendTo('body')

  # teardown div and any modal that was created
  afterEach ->
    modalView?.options?.fadeOut = false
    modalView?.hide?()
    modalView?.destroy?()
    $div?.remove?()


  it 'should be part of athena.lib', ->
    expect(ModalView).toBeDefined()


  describeView = athena.lib.util.test.describeView
  describeView ModalView, athena.lib.View, ->

    it 'should look good and work well', ->
      modalView = new ModalView title: 'Grand Modal of Platonic Intentions'
      button = $('<button>').addClass('btn btn-primary').text('Show Modal')
          .click(modalView.show)

      modalView.render()
      modalView.$('.modal-body').html '<p>Welcome to my body.</p>'

      $div.append modalView.el
      $div.append button

      # unhinge modalView and div variables to avoid destruction in afterEach
      modalView = undefined
      $div = undefined


    test.describeDefaults ModalView,
      title: ''
      closeButtonName: 'Close'
      show: false
      fadeIn: true
      fadeOut: false
      backdrop: true


    it 'should display a title when passed in as an option', ->
      title = 'Grand Modal of Platonic Intentions'

      modalView = new ModalView title: title
      $div.append modalView.render().el

      expect(modalView.$('.modal-title').text()).toBe title

    it 'should by default display a close button with name "Close"', ->
      modalView = new ModalView
      $div.append modalView.render().el

      expect(modalView.$('.modal-footer').find('.close').text()).toBe 'Close'

    it 'should display a close button with a configurable name', ->
      buttonName = 'Cancel'

      modalView = new ModalView closeButtonName: buttonName
      $div.append modalView.render().el

      expect(modalView.$('.modal-footer').find('.close').text()).toBe buttonName


  cdescribe 'ModalView: display management', ->

    it 'should by default not show the modal', ->
      modalView = new ModalView disableTransitionOptions()
      $div.append modalView.render().el
      expectModalShownStatus modalView, false

    it 'should show the modal when passed `show:true`', ->
      modalView = new ModalView _.extend(disableTransitionOptions(), show: true)
      $div.append modalView.render().el
      expectModalShownStatus modalView, true

    it 'should have a `show` method that shows the modal', ->
      modalView = new ModalView disableTransitionOptions()
      $div.append modalView.render().el
      expectModalShownStatus modalView, false

      modalView.show()
      expectModalShownStatus modalView, true

    it 'should have a `hide` method that hides the modal', ->
      modalView = new ModalView _.extend(disableTransitionOptions(), show: true)
      $div.append modalView.render().el
      expectModalShownStatus modalView, true

      modalView.hide()
      expectModalShownStatus modalView, false



  describe 'ModalView: events', ->


    describe 'ModalView: change display events', ->

      # no need for special options
      beforeEach ->
        modalView = new ModalView disableTransitionOptions()
        $div.append modalView.render().el

      cit 'should call `_onShow` just before modal shows', ->
        spyOn(modalView, '_onShow').andCallFake runOnce ->
          expectModalShownStatus modalView, false

        expectModalShownStatus modalView, false
        expect(modalView._onShow).not.toHaveBeenCalled()

        modalView.show()
        expect(modalView._onShow).toHaveBeenCalled()
        expectModalShownStatus modalView, true

      cit 'should call `_onShown` just after modal shows', ->
        spyOn(modalView, '_onShown').andCallFake runOnce ->
          expectModalShownStatus modalView, true

        expectModalShownStatus modalView, false
        expect(modalView._onShown).not.toHaveBeenCalled()

        modalView.show()
        expect(modalView._onShown).toHaveBeenCalled()
        expectModalShownStatus modalView, true

      cit 'should call `_onHide` just before modal hides', ->
        modalView.show()

        spyOn(modalView, '_onHide').andCallFake runOnce ->
          expectModalShownStatus modalView, true

        expectModalShownStatus modalView, true
        expect(modalView._onHide).not.toHaveBeenCalled()

        modalView.hide()
        expect(modalView._onHide).toHaveBeenCalled()
        expectModalShownStatus modalView, false

      cit 'should call `_onHidden` just after modal hides', ->
        modalView.show()

        spyOn(modalView, '_onHidden').andCallFake runOnce ->
          expectModalShownStatus modalView, false

        expectModalShownStatus modalView, true
        expect(modalView._onHidden).not.toHaveBeenCalled()

        modalView.hide()
        expect(modalView._onHidden).toHaveBeenCalled()
        expectModalShownStatus modalView, false

      it 'should trigger show event before running `_onShow`', ->
        spyOn(modalView, '_onShow').andCallThrough()
        eventTriggered = false

        modalView.on 'show', runOnce ->
          eventTriggered = true
          expect(modalView._onShow).not.toHaveBeenCalled()

        expect(modalView._onShow).not.toHaveBeenCalled()

        modalView.show()
        expect(eventTriggered).toBe true
        expect(modalView._onShow).toHaveBeenCalled()

      it 'should trigger shown event after running `_onShown`', ->
        spyOn(modalView, '_onShown').andCallThrough()
        eventTriggered = false

        modalView.on 'shown', runOnce ->
          eventTriggered = true
          expect(modalView._onShown).toHaveBeenCalled()

        expect(modalView._onShown).not.toHaveBeenCalled()

        modalView.show()
        expect(eventTriggered).toBe true
        expect(modalView._onShown).toHaveBeenCalled()

      it 'should trigger hide event before running `_onHide`', ->
        modalView.show()

        spyOn(modalView, '_onHide').andCallThrough()
        eventTriggered = false

        modalView.on 'hide', runOnce ->
          eventTriggered = true
          expect(modalView._onHide).not.toHaveBeenCalled()

        expect(modalView._onHide).not.toHaveBeenCalled()

        modalView.hide()
        expect(eventTriggered).toBe true
        expect(modalView._onHide).toHaveBeenCalled()

      it 'should trigger hidden event after running `_onHidden`', ->
        modalView.show()

        spyOn(modalView, '_onHidden').andCallThrough()
        eventTriggered = false

        modalView.on 'hidden', runOnce ->
          eventTriggered = true
          expect(modalView._onHidden).toHaveBeenCalled()

        expect(modalView._onHidden).not.toHaveBeenCalled()

        modalView.hide()
        expect(eventTriggered).toBe true
        expect(modalView._onHidden).toHaveBeenCalled()


    describe 'ModalView: keyup events', ->

      # no need for special options
      beforeEach ->
        modalView = new ModalView disableTransitionOptions()
        $div.append modalView.render().el

      it 'should call ModalView::_onGlobalKeyupEnter when enter is pressed while
          modal is shown', ->
        modalView.show()

        spyOn modalView, '_onGlobalKeyupEnter'

        keyupEnter = $.Event 'keyup'
        keyupEnter.keyCode = keys.ENTER

        expect(modalView._onGlobalKeyupEnter).not.toHaveBeenCalled()
        modalView.$el.trigger keyupEnter
        expect(modalView._onGlobalKeyupEnter).toHaveBeenCalled()

      it 'should call ModalView::_onGlobalKeyupEscape when escape is pressed
          while modal is shown', ->
        modalView.show()

        spyOn modalView, '_onGlobalKeyupEscape'

        keyupEscape = $.Event 'keyup'
        keyupEscape.keyCode = keys.ESCAPE

        expect(modalView._onGlobalKeyupEscape).not.toHaveBeenCalled()
        modalView.$el.trigger keyupEscape
        expect(modalView._onGlobalKeyupEscape).toHaveBeenCalled()

      cit 'should hide modal when enter is pressed while modal is shown', ->
        modalView.show()

        keyupEnter = $.Event 'keyup'
        keyupEnter.keyCode = keys.ENTER

        expectModalShownStatus modalView, true
        modalView.$el.trigger keyupEnter
        expectModalShownStatus modalView, false

      cit 'should hide modal when escape is pressed while modal is shown', ->
        modalView.show()

        keyupEscape = $.Event 'keyup'
        keyupEscape.keyCode = keys.ESCAPE

        expectModalShownStatus modalView, true
        modalView.$el.trigger keyupEscape
        expectModalShownStatus modalView, false


    cdescribe 'ModalView: click dismiss-modal event', ->

      it 'should hide when an element with a dismiss-modal class is clicked', ->
        modalView = new ModalView disableTransitionOptions()
        $div.append modalView.render().el

        modalView.show()
        expectModalShownStatus modalView, true

        # close button in header
        modalView.$('.modal-header').find('button').click()
        expectModalShownStatus modalView, false

        modalView.show()
        expectModalShownStatus modalView, true

        # close button in footer
        modalView.$('.modal-footer').find('a').click()
        expectModalShownStatus modalView, false

        modalView.show()
        expectModalShownStatus modalView, true

        # custom close button
        modalBody = modalView.$ '.modal-body'
        $('<button>').addClass('dismiss-modal').appendTo(modalBody).click()
        expectModalShownStatus modalView, false


    cdescribe 'ModalView: click backdrop event', ->

      it 'should by default hide when the backdrop is clicked', ->
        modalView = new ModalView disableTransitionOptions()
        $div.append modalView.render().el

        modalView.show()
        expectModalShownStatus modalView, true

        $('.modal-backdrop').click()
        expectModalShownStatus modalView, false

      it "should not hide when the backdrop is clicked if passed
          `backdrop:'static'`", ->
        modalView = new ModalView _.extend disableTransitionOptions(),
            backdrop: 'static'
        $div.append modalView.render().el

        modalView.show()
        expectModalShownStatus modalView, true

        $('.modal-backdrop').click()
        expectModalShownStatus modalView, true


  cdescribe 'ModalView: transitions', ->

    it 'should by default fade in when shown', ->
      modalView = new ModalView
      $div.append modalView.render().el

      shown = false
      modalView.on 'shown', -> shown = true

      runs ->
        modalView.show()
        expectModalShownStatus modalView, false

      waitsFor (-> shown), 'modal to show', 2000

      runs ->
        expectModalShownStatus modalView, true

    it 'should fade in when shown if passed `fadeIn:true`', ->
      modalView = new ModalView fadeIn: true
      $div.append modalView.render().el

      shown = false
      modalView.on 'shown', -> shown = true

      runs ->
        modalView.show()
        expectModalShownStatus modalView, false

      waitsFor (-> shown), 'modal to show', 2000

      runs ->
        expectModalShownStatus modalView, true

    it 'should not fade in when shown if passed `fadeIn:false`', ->
      modalView = new ModalView fadeIn: false
      $div.append modalView.render().el

      modalView.show()
      expectModalShownStatus modalView, true

    it 'should by default not fade out when hidden', ->
      modalView = new ModalView fadeIn: false
      $div.append modalView.render().el

      hidden = true
      modalView.on 'hidden', -> hidden = true

      modalView.show()
      expectModalShownStatus modalView, true

      modalView.hide()
      expectModalShownStatus modalView, false

    it 'should fade out when hidden if passed `fadeOut:true`', ->
      modalView = new ModalView fadeIn: false, fadeOut: true
      $div.append modalView.render().el

      hidden = false
      modalView.on 'hidden', -> hidden = true

      modalView.show()
      expectModalShownStatus modalView, true

      runs ->
        modalView.hide()
        expectModalShownStatus modalView, true

      waitsFor (-> hidden), 'modal to hide', 2000

      runs ->
        expectModalShownStatus modalView, false

    it 'should not fade out when hidden if passed `fadeOut:false`', ->
      modalView = new ModalView fadeIn: false, fadeOut: false
      $div.append modalView.render().el

      hidden = true
      modalView.on 'hidden', -> hidden = true

      modalView.show()
      expectModalShownStatus modalView, true

      modalView.hide()
      expectModalShownStatus modalView, false
