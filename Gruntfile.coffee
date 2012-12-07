module.exports = (grunt) ->

  # Project configuration.
  config =
    pkg: grunt.file.readJSON 'package.json'

    paths:
      coffee: 'coffee/**/*.coffee'
      js: 'js/**/*.js'
      min: 'build/athena.lib.min.js'
      srcs: 'js/src/**/*.js'
      closure:
        deps: 'js/deps.js'
        main: 'js/src/lib.js'
        library: 'lib/closure/library'
        compiler: 'lib/closure/compiler.jar'

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

    clean:
      js: ['<%= paths.js %>']

  # adjust config - needed because some modules dont process templates nicely
  config.closureCompiler.lib.closureCompiler = config.paths.closure.compiler
  config.closureCompiler.lib.options.js_output_file = config.paths.min
  config.closureDepsWriter.lib.options.output_file = config.paths.closure.deps

  # load config
  grunt.initConfig config

  # Load tasks
  grunt.loadNpmTasks 'grunt-coffee'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-closure-tools'

  # Register tasks
  grunt.registerTask 'compile', ['coffee', 'closureCompiler']
  grunt.registerTask 'sources', ['coffee', 'closureDepsWriter']
  grunt.registerTask 'default', ['compile']
