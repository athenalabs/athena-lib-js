goog.provide 'athena.lib.util'

# Helper to check the inheritance chain.
athena.lib.util.derives = derives = (child, parent) ->

  if !child || !child.__super__
    return false

  if parent.prototype is child.__super__
    return true

  return derives child.__super__.constructor, parent
