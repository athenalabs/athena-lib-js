module.exports = (grunt) ->

  # Project configuration.
  config =
    pkg: grunt.file.readJSON 'package.json'

    paths:
      coffee: 'coffee/**/*.coffee'
      js: 'js/**/*.js'
      min: 'build/athena.lib.min.js'
      srcs: 'js/src/**/*.js'
      specs: 'js/test/**/*.spec.js'
      closure:
        deps: 'js/deps.js'
        main: 'js/src/lib.js'
        library: 'lib/closure/library'
        compiler: 'lib/closure/compiler.jar'
      libs: [
        'node_modules/jquery-browser/lib/jquery.js'
        'node_modules/underscore/underscore.js'
        'node_modules/backbone/backbone.js'
        'lib/bootstrap/bootstrap.min.js'
        'lib/closure/library/closure/goog/base.js'
      ]

    ####################
    # Tasks
    ####################

    coffee:
      app:
        src: '<%= paths.coffee %>'
        dest: 'js'
        options:
          preserve_dirs: true
          base_path: 'coffee'

    closureCompiler:
      lib:
        js: '<%= paths.srcs %>'
        # closureCompiler: '<%= paths.closure.compiler %>' - adjusted
        checkModified: true
        options:
           # compilation_level: 'ADVANCED_OPTIMIZATIONS',
           # externs: ['path/to/file.js', '/source/**/*.js'],
           # define: ["'goog.DEBUG=false'"],
           # warning_level: 'verbose',
           # jscomp_off: ['checkTypes', 'fileoverviewTags'],
           # summary_detail_level: 3,
           # js_output_file = '<%= paths.min %> - adjusted
           output_wrapper: '"(function(){%output%}).call(this);"'

    closureDepsWriter:
      lib:
        closureLibraryPath: '<%= paths.closure.library %>'
        options:
          # output_file: '<%= config.paths.closure.deps %>' - adjusted
          root_with_prefix: '"js ../../../../../js"',

    jasmine:
      # modified below, to include libs
      # src: '<%= paths.srcs %>'
      specs: '<%= paths.specs %>'

    watch:
      files: '<%= paths.coffee %>'
      tasks: 'sources'

    testserver:
      # lib: '<%= paths.libs %>' - adjusted
      # src: '<%= paths.srcs %>' - adjusted
      min: '<%= paths.min %>'
      specs: '<%= paths.specs %>'

    clean:
      js: ['<%= paths.js %>']
      test: ['_SpecRunner.html']

  # adjust config - needed because some modules dont process templates nicely
  srcs = [config.paths.closure.deps, config.paths.closure.main]
  config.jasmine.src = [].concat config.paths.libs, srcs
  config.testserver.lib = config.paths.libs
  config.testserver.src = srcs

  config.closureCompiler.lib.closureCompiler = config.paths.closure.compiler
  config.closureCompiler.lib.options.js_output_file = config.paths.min
  config.closureDepsWriter.lib.options.output_file = config.paths.closure.deps

  # load config
  grunt.initConfig config

  # Load tasks
  grunt.loadNpmTasks 'grunt-coffee'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-closure-tools'
  grunt.loadNpmTasks 'grunt-jasmine-runner'
  grunt.loadTasks 'js/tasks'

  # Register tasks
  grunt.registerTask 'compile', ['coffee', 'closureCompiler']
  grunt.registerTask 'sources', ['coffee', 'closureDepsWriter']
  grunt.registerTask 'test', ['sources', 'jasmine']
  grunt.registerTask 'server', ['sources', 'testserver', 'watch']
  grunt.registerTask 'default', ['compile']
