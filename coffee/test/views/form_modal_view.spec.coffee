goog.provide 'athena.lib.specs.FormModalView'
goog.require 'athena.lib.FormModalView'
goog.require 'athena.lib.util.test'


describe 'athena.lib.FormModalView', ->
  FormModalView = athena.lib.FormModalView
  keys = athena.lib.util.keys

  $div = undefined
  fmv = undefined

  beforeEach ->
    $div = $('<div>').addClass('athena-lib-test').appendTo('body')

  # teardown div and any modal that was created
  afterEach ->
    fmv?.options?.fadeOut = false
    fmv?.hide?()
    fmv?.destroy?()
    $div?.remove?()


  it 'should be part of athena.lib', ->
    expect(FormModalView).toBeDefined()


  describeView = athena.lib.util.test.describeView
  describeView FormModalView, athena.lib.View, ->

    it 'should look good and work well', ->
      fmv = new FormModalView
      button = $('<button>').addClass('btn btn-primary')
          .text('Show Form Modal').click(fmv.show)

      $div.append fmv.render().el
      $div.append button

      # unhinge fmv and div variables to avoid destruction in afterEach
      fmv = undefined
      $div = undefined


    test.describeDefaults FormModalView,
      title: 'Form'
      closeButtonName: 'Cancel'
      submitButtonName: 'Submit'


    it 'should display a submit button with default name "Submit"', ->
      fmv = new FormModalView
      fmv.render()

      expect(fmv.$('.btn.submit').text()).toBe 'Submit'


  describe 'FormModalView: submission', ->

    it 'should fire submit event on clicking submit button', ->
      fmv = new FormModalView
      fmv.render()

      submission = false
      fmv.on 'FormModalView:Submit', -> submission = true

      fmv.$('.btn.submit').click()
      expect(submission).toBe true

    it 'should call `onSubmit` callback on clicking submit button', ->
      submission = false
      fmv = new FormModalView onSubmit: -> submission = true
      fmv.render()

      fmv.$('.btn.submit').click()
      expect(submission).toBe true


  it 'should have a values method that returns values', ->
    fmv = new FormModalView
    fmv.render()

    text = 'haiii'
    fmv._textareaInputView.value text
    expect(fmv.values().textarea).toBe text
