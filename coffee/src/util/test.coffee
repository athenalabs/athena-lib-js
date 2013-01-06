goog.provide 'athena.lib.util.test'

test = athena.lib.util.test



# constructs, renders, and displays view
test.view_with_options = (options, ViewClass, appendTo) ->
  ViewClass = ViewClass or lib.View
  appendTo = appendTo or 'body'
  view = new ViewClass options
  view.render()
  $(appendTo).append view.$el
  view



# constructs, renders, and displays view with content
test.view_with_content = (content) ->
  view = test.view_with_options.apply @, _.rest arguments
  view.$el.append content
  view



# Returns true if `fn` throws an exception whose message contains `str` when
# called with parameters in array `args`. Returns false otherwise.
# Returns false otherwise.
test.throwsExceptionWithString = (str, fn, args) ->
  success = false

  if args?
    unless args instanceof Array
      args = [ args ]
  else
    args = []

  try fn args... catch error
    success = error.message.search(str) >= 0

  success



# creates a jasmine describeProperty block
test.describeProperty = (Model, name, options, propOptions, tests) ->

  options ?= {}
  propOptions ?= {}
  propOptions.setter ?= true

  describe "#{Model.name}::#{name}", ->

    it 'should be a function', ->
      expect(typeof Model::[name]).toBe 'function'

    it 'should get the value of the attribute', ->
      m = new Model options
      expect(m[name]()).toEqual (propOptions.default ? m.get name)
      m.set name, 'foo'
      expect(m[name]()).toEqual m.get name
      expect(m[name]()).toEqual 'foo'

    if propOptions.setter is false
      it 'should NOT set the value of the attribute (setter is false)', ->
        m = new Model options
        expect(m[name]()).toEqual (propOptions.default ? m.get name)
        expect(m[name]()).not.toEqual 'foo'
        expect(m[name]('foo')).toEqual (propOptions.default ? m.get name)
        expect(m[name]()).toEqual (propOptions.default ? m.get name)
        expect(m[name]()).not.toEqual 'foo'

    else
      it 'should set the value of the attribute', ->
        m = new Model options
        expect(m[name]()).not.toEqual 'foo'
        expect(m[name]()).toEqual (propOptions.default ? m.get name)
        expect(m[name]('foo')).toEqual m.get name
        expect(m[name]()).toEqual 'foo'

    it "should use default value #{propOptions.default}", ->
      m = new Model options
      if propOptions.default?
        expect(m.get name).not.toEqual propOptions.default

      if m.get(name)
        expect(m[name]()).toEqual m.get(name)
      else if options[name]? and options[name] != propOptions.default
        expect(m[name]()).not.toEqual propOptions.default
      else
        expect(m[name]()).toEqual propOptions.default

    tests?()



# creates a jasmine describeView block
test.describeView = (View, SuperView, options, tests) ->

  # accept tests as third argument
  if typeof options == 'function'
    tests = options
    options = {}

  options ?= {}

  describe "#{View.name}: view tests", ->

    it 'should be a function', ->
      expect(typeof View).toBe 'function'

    it "should derive from #{SuperView.name}", ->
      expect(athena.lib.util.derives View, SuperView).toBe true

    it 'should be constructible with given options', ->
      expect(-> new View options).not.toThrow()
      view = new View options
      expect(view instanceof View).toBe true
      expect(view.options).toBe options

    it 'should have a className property of type string', ->
      expect(typeof View.prototype.className).toBe 'string'

    it 'should have a defaults function, that returns an object', ->
      expect(typeof View.prototype.defaults).toBe 'function'
      view = new View options
      expect(typeof view.defaults()).toBe 'object'

    it 'should have an events function, that returns an object', ->
      expect(typeof View.prototype.events).toBe 'function'
      view = new View options
      expect(typeof view.events()).toBe 'object'

    it 'should have an elAttributes function, that returns an object', ->
      expect(typeof View.prototype.events).toBe 'function'
      view = new View options
      expect(typeof view.events()).toBe 'object'

    it 'should have render return @', ->
      view = new View(options)
      expect(view.render()).toBe view

    it 'should be rendering after render (i.e. should call super)', ->
      view = new View(options)
      expect(view.rendering).toBe false

      view.render()
      expect(view.rendering).toBe true

    tests?()



# creates a jasmine describeDefaults block
test.describeDefaults = (Klass, defaults, options, tests) ->

  options ?= {}

  describe "#{Klass.name}::defaults", ->

    objectDefaults = new Klass(options).defaults()

    _.each defaults, (value, name) ->
      it "should have options.#{name} default to #{JSON.stringify(value)}", ->
        expect(objectDefaults[name]).toEqual value



# creates a describeSubview block
test.describeSubview = (options, tests) ->

  View = options.View
  viewOptions = options.viewOptions

  subviewAttr = options.subviewAttr
  Subview = options.Subview

  checkDOM = options.checkDOM
  checkDOM ?= (childEl, parentEl) -> childEl.parentNode is parentEl


  describe "#{View.name}::#{subviewAttr} subview", ->

    it 'should be defined on init', ->
      view = new View viewOptions
      expect(view[subviewAttr]).toBeDefined()

    it "should be an instanceof #{Subview.name}", ->
      view = new View viewOptions
      expect(view[subviewAttr] instanceof Subview).toBe true

    it 'should not be rendering initially', ->
      view = new View viewOptions
      expect(view[subviewAttr].rendering).toBe false

    it "should be rendering with #{View.name}", ->
      view = new View viewOptions
      view.render()
      expect(view[subviewAttr].rendering).toBe true

    it "should share eventhub with #{View.name}", ->
      view = new View viewOptions
      view.render()
      expect(view[subviewAttr].eventhub).toBe view.eventhub

    it "should be a DOM child of the #{View.name}", ->
      view = new View viewOptions
      view.render()
      expect(checkDOM view[subviewAttr].el, view.el).toBe true

    tests?()



# creates a describeFormComponent block
test.describeFormComponent = (options, tests) ->

  View = options.View
  name = options.name

  describe "#{View.name}::#{name}", ->

    it 'should be a FormComponentView', ->
      view = new View
      expect(view[name] instanceof athena.lib.FormComponentView).toBe true

    if athena.lib.util.derives View, athena.lib.FormView
      it "should be added to #{View.name}::componentViews", ->
        view = new View
        expect(_.contains view.componentViews, view[name]).toBe true

      it "should share the eventhub with #{View.name}", ->
        view = new View
        expect(view[name].eventhub).toBe view.eventhub

    fieldOptions = 'id type label placeholder helpBlock helpInline'.split(' ')
    _.each fieldOptions, (option) ->
      if options[option]
        it "should have #{option}: #{options[option]}", ->
          view = new View
          expect(view[name].options[option]).toBe options[option]

    tests?()



# a jasmine-style spy for Backbone events
class test.EventSpy


  constructor: (@target, @eventName) ->
    @reset()
    @target.on eventName ? 'all', @trigger


  reset: =>
    @triggered = false
    @triggerCount = 0
    @_callsSinceLastCheck = 0
    @arguments = []


  trigger: =>
    @triggered = true
    @triggerCount++
    @_callsSinceLastCheck++
    @arguments.push _.toArray arguments


  callsSinceLastCheck: =>
    calls = @_callsSinceLastCheck
    @_callsSinceLastCheck = 0
    calls



# Tests that each of an array of functions causes expected EventSpy behavior.
#
# spies: an object of EventSpy instances.
# fns: an array of functions to run, each of which returns an object containing
#   expected spy behaviors. The keys of this object should match the keys of
#   the spies expected to have been triggered; when a key's value is not
#   undefined, that spy's call arguments will be tested as well.
test.expectEventSpyBehaviors = (spies, fns) ->
  # run each action and extract expectations about which spies were called
  for fn in fns
    expectations = fn() ? {}

    for spyName, spy of spies
      expectedCall = expectations.hasOwnProperty spyName
      callsSinceLastCheck = spy.callsSinceLastCheck()
      expect(!!callsSinceLastCheck).toBe expectedCall

      # if an event with particular arguments was expected, test that it was
      # called with those arguments
      if expectedCall and (args = expectations[spyName])?
        args = [args] unless _.isArray args
        expect(_.last spy.arguments).toEqual args



# disable an it block in a way that displays warnings in tests
test.xit = (description, fn, warning) ->
  warning ?= '---- TODO'
  message = "#{warning}: #{description}"
  console.log message
  it message, ->



# disable a describe block in a way that displays warnings in tests
test.xdescribe = (description, fn, warning) ->
  warning ?= '---- TODO'
  message = "#{warning}: #{description}"
  console.log message
  describe message, ->
    it '', ->



# conditionally disable test blocks in a way that displays warnings in tests
test.conditionalDisablers = (disabled = true, warning) ->
  warning ?= 'Conditionally Disabled'

  # disabled it
  dit = (description, fn) ->
    test.xit description, fn, warning

  # disabled describe
  ddescribe = (description, fn) ->
    test.xdescribe description, fn, warning

  # warning it
  wit = (description, fn) ->
    console.log "#{warning}: #{description}"
    it arguments...

  # warning describe
  wdescribe = (description, fn) ->
    console.log "#{warning}: #{description}"
    describe arguments...

  if disabled
    [dit, ddescribe]
  else
    [wit, wdescribe]
