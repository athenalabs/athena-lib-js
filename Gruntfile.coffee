module.exports = (grunt) ->

  # Project configuration.
  config =
    pkg: grunt.file.readJSON 'package.json'

    paths:
      coffee: 'coffee/**/*.coffee'
      js: 'js/**/*.js'

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

  # load config
  grunt.initConfig config

  # Load tasks
  grunt.loadNpmTasks 'grunt-coffee'

  # Register tasks
  grunt.registerTask 'compile', ['coffee']
  grunt.registerTask 'default', ['compile']
