module.exports = (grunt) ->

  # Nodejs libs.
  path = require 'path'

  # External libs.
  express = require 'express'

  _ = grunt.utils._

  # Task configuration
  parse_config = ->
    config = grunt.config 'testserver'

    if not config
      grunt.log.error 'No configuration for testserver'
      return false

    _.each ['lib', 'src', 'min', 'specs'], (key) ->
      if not config[key]
        grunt.log.error "testserver config missing #{key}"

    _.defaults config,
      port: 8000
      base: '.'
      view: 'lib/jasmine/testserver.html'

    return config

  # Tasks
  grunt.registerTask 'testserver', 'Start a test server.', ->
    config = parse_config grunt

    if grunt.task.current.errorCount
      return false

    # Prepare values from config
    view = config.view
    port = config.port
    base = path.resolve config.base

    # values
    values =
      _: _
      lib: grunt.file.expandFiles config.lib
      src: grunt.file.expandFiles config.src
      min: grunt.file.expandFiles config.min
      specs: grunt.file.expandFiles config.specs
      special: ['all', 'minified']

    # server setup
    app = express()

    # setup ejs templating engine
    app.engine 'html', require('ejs').renderFile

    # setup views path
    app.set 'views', base

    # one spec
    app.get /^\/spec/, (req, res, next) ->
      spec = req.path.replace(/^\/spec\//, '')
      res.render view, _.extend(run: [spec], values)

    # static files
    app.get /^\/((node_modules|build|js|lib)\/.*)/, (req, res) ->
      res.sendfile req.params[0]

    # index
    app.get '/', (req, res) ->
      res.render view, _.extend(run: [], values)

    grunt.log.writeln "listening on http://localhost:#{port}"
    app.listen port
