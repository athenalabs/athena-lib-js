goog.provide 'athena.lib.util.RemoteResource'
goog.provide 'athena.lib.util.RemoteResourceInterface'

goog.require 'athena.lib.util'

util = athena.lib.util

class util.RemoteResourceInterface
  url: ->
  data: ->
  reset: ->
  synced: -> true
  sync: (params) ->
    if params.success
      params.success @data()


class util.RemoteResource extends util.RemoteResourceInterface

  constructor: (params) ->
    @params = _.clone params

    if not @params.url
      throw new Error 'remoteResource `url` AJAX param required for sync.'

    @url(@params.url)

  url: (url_) =>
    if url_
      @reset()
      @_url = url_
    @_url

  data: =>
    if not @_synced
      throw new Error 'not synced. cannot access data.'

    _.clone @_data

  reset: =>
    @_synced = false
    @_data = undefined

  synced: =>
    @_synced

  # synchronizes local data with whatever exists on the remote
  # Alrgs:
  # * syncParams:
  #   * force (boolean): forces remote fetch even if local value exists
  #   * jQuery ajax params: success/error callbacks, etc.
  sync: (syncParams = {}) =>
    if syncParams.url
      throw new Error 'remoteResource.sync doesn\'t take url parameter.'

    syncParams = _.extend {}, @params, syncParams

    # extracting success callback
    success_callback = syncParams.success || (->)

    if @_synced and not syncParams.force
      success_callback @data()
      return @

    syncParams.url = @_url
    syncParams.success = (data, textStatus, jqXHR) =>
      @_data = data
      @_synced = true
      success_callback @data(), textStatus, jqXHR

    $.ajax syncParams
    return @
