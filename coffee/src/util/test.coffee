goog.provide 'athena.lib.util.test'

test = athena.lib.util.test

# construct, render, and display view
test.view_with_options = (options, ViewClass, appendTo) ->
  ViewClass = ViewClass || lib.View
  appendTo = appendTo || 'body'
  view = new ViewClass options
  view.render()
  $(appendTo).append view.$el
  view

# construct, render, and display view with content
test.view_with_content = (content) ->
  view = test.view_with_options.apply @, _.rest arguments
  view.$el.append content
  view


# Returns true if `fn` throws an exception whose message contains `str` when
# called with parameters in array `args`.
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

# Utility function to create a describeSubview block
test.describeSubview = (options, tests) ->

  View = options.View
  viewOptions = options.viewOptions

  subviewAttr = options.subviewAttr
  SubView = options.SubView

  describe "#{View.name}::#{subviewAttr} subview", ->

    it 'should be defined on init', ->
      view = new View viewOptions
      expect(view[subviewAttr]).toBeDefined()

    it "should be an instanceof #{SubView.name}", ->
      view = new View viewOptions
      expect(view[subviewAttr] instanceof SubView)

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
      expect(view[subviewAttr].el.parentNode).toEqual view.el

    tests?()


# a jasmine-style spy for Backbone events.
class test.EventSpy

  constructor: (@target, @eventName) ->
    @reset()
    @target.on eventName ? 'all', @trigger

  reset: =>
    @triggered = false
    @triggerCount = 0

  trigger: =>
    @triggered = true
    @triggerCount++
