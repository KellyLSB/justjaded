# grunt-jaded
# http://kellybecker.me
#
# Copyright (c) 2014 Kelly Becker
# Licensed under the MIT license.
'use strict'

module.exports = (grunt) ->
  Tusk = require('grunt-tusks').init grunt, ->
    @JsYaml = require('js-yaml')
    @Jade   = require('../lib/jade')
    @Yaml   = require('../lib/yaml')

  grunt.registerMultiTask 'justjaded', 'Static Site Generator.', ->
    options = this.options
      # Project
      buildDir: Tusk.projectRoot
      assetDir: 'assets'
      # Jade
      jadeFilters: {}
      jadeOptions: {}
      jadeData:    {}
      jadeInit: -> {}
      # Generic
      pretty: true
      debug: false

    # Resolve the Asset Directory
    # from the Build Directory
    options.assetDir =
      Tusk.Library.File.resolve \
        options.assetDir,
        options.buildDir

    # Read the source files with Grunt
    options.gruntReadSourceFiles = true

    # Create a new Task Helper
    tusk = new Tusk(@, options)

    # Start processing files
    tusk.forFiles 'jade', (file, dest) ->

      # Load associated page data from Yaml
      yamlDir  = file.name
        .replace /^(.*)(jade!?)(.*)$/gi, '$1yaml'
      yamlName = @File.resolve(dest.name, yamlDir)
      yamlPath = yamlName.concat('.yaml')
      yamlData = @Yaml.loadFile(yamlPath) || {}

      # Prepare the Jade template processor
      @Jade.prep.call(@, file, dest, yamlData)

      # ... and Compile away
      @Jade.compile(file.data, @jadeOptions)(@jadeData)
