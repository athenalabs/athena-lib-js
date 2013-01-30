goog.provide 'athena.lib.util'

util = athena.lib.util

# Helper to check the inheritance chain.
util.derives = derives = (child, parent) ->

  if !child || !child.__super__
    return false

  if parent.prototype is child.__super__
    return true

  derives child.__super__.constructor, parent

util.isOrDerives = (child, parent) ->
  child == parent or derives child, parent

util.isStrictObject = (obj) ->
  obj?.toString() == '[object Object]'


# Check if an element or set of elements is in the DOM
util.elementInDom = (element) ->
  if element instanceof $
    return _.all element, util.elementInDom

  while element = element?.parentNode
    if element == document
      return true

  return false
