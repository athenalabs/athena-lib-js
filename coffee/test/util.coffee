goog.provide 'athena.lib.test.util'

test = athena.lib.test

# construct, render, and display view
test.util.view_with_options = (options, viewClass, appendTo) ->
  viewClass = viewClass || lib.View
  appendTo = appendTo || '.athena-test'
  view = new viewClass options;
  view.render()
  $(appendTo).append view.$el;
  view

# construct, render, and display view with content
test.util.view_with_content = (content) ->
  view = test.util.view_with_options.apply @, _.rest arguments
  view.$el.append content
  view

# a jasmine-style spy for Backbone events.
class test.util.eventSpy

  constructor: (@target, @eventName) ->
    @reset()
    @target.on eventName, @trigger

  reset: =>
    @triggered = false
    @triggerCount = 0

  trigger: =>
    @triggered = true
    @triggerCount++
