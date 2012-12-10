goog.provide 'athena.lib.util.RemoteResourceInterface.spec'
goog.provide 'athena.lib.util.RemoteResource.spec'

goog.require 'athena.lib.util.RemoteResourceInterface'
goog.require 'athena.lib.util.RemoteResource'

util = athena.lib.util;
RemoteResource = util.RemoteResource;
RemoteResourceInterface = util.RemoteResourceInterface;


describe 'RemoteResourceInterface', ->
  it 'should be part of athena.lib.util', ->
    expect(athena.lib.util.RemoteResourceInterface).toBeDefined()

  it 'should be a function', ->
    expect(_.isFunction RemoteResourceInterface).toBe true

  it 'should have a url function', ->
    expect(_.isFunction RemoteResourceInterface::url).toBe true

  it 'should have a data function', ->
    expect(_.isFunction RemoteResourceInterface::data).toBe true

  it 'should have a reset function', ->
    expect(_.isFunction RemoteResourceInterface::reset).toBe true

  it 'should have a synced function', ->
    expect(_.isFunction RemoteResourceInterface::synced).toBe true

  it 'should have a sync function', ->
    expect(_.isFunction RemoteResourceInterface::sync).toBe true


describe 'RemoteResource', ->
  it 'should be part of athena.lib.util', ->
    expect(athena.lib.util.RemoteResource).toBeDefined()

  it 'should derive from RemoteResourceInterface', ->
    expect(util.derives RemoteResource, RemoteResourceInterface).toBe true

  it 'should be tested from the server', ->
    expect(window.location.host).not.toBe('')

  if not window.location.host
    return

  internal_data = undefined
  proxy = new util.RemoteResource
    url: 'http://' + window.location.host

  it 'throws error on unsynced fetch', ->
    expect(proxy.data).toThrow()

  it 'supports remote sync', ->
    dataMatch = false;
    runs ->
      proxy.sync
        success: (data, textStatus, jqXHR) ->
          internal_data = data
          dataMatch = (proxy.data() is internal_data)

    waitsFor (-> dataMatch), 'data match failure'
    runs ->
      expect(dataMatch).toBe true
      expect(proxy.synced()).toBe true

  it 'supports local fetch', ->
    expect(proxy.data() is internal_data).toBe true

  it 'supports reset', ->
    proxy.reset()
    expect(proxy.data).toThrow()

