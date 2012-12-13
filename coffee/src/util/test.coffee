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
  args ?= []
  try fn args... catch error
    success = error.message.search(str) >= 0

  success


# a jasmine-style spy for Backbone events.
class test.EventSpy

  constructor: (@target, @eventName) ->
    @reset()
    @target.on eventName, @trigger

  reset: =>
    @triggered = false
    @triggerCount = 0

  trigger: =>
    @triggered = true
    @triggerCount++
