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

# creates a jasmine describeView block
test.describeView = (View, SuperView, options, tests) ->

  # accept tests as third argument
  if typeof options == 'function'
    tests = options
    options = {}

  options ?= {}

  describe "#{View.name} view tests", ->

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

    it "should be a DOM child of the #{View.name}", ->
      view = new View viewOptions
      view.render()
      expect(checkDOM view[subviewAttr].el, view.el).toBe true

    tests?()


# a jasmine-style spy for Backbone events
class test.EventSpy

  constructor: (@target, @eventName) ->
    @reset()
    @target.on eventName ? 'all', @trigger

  reset: =>
    @triggered = false
    @triggerCount = 0
    @arguments = []

  trigger: =>
    @triggered = true
    @triggerCount++
    @arguments.push _.toArray arguments
