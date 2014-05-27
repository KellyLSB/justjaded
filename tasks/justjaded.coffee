# grunt-jaded
# http://kellybecker.me
#
# Copyright (c) 2014 Kelly Becker
# Licensed under the MIT license.
'use strict'

module.exports = (grunt) ->

  # Node Lib.
  Path = require('path')

  # Internal lib.
  Chalk = require('chalk')
  Merge = require('coffee-script').helpers.merge
  Extend = require('coffee-script').helpers.extend

  # Variables
  projectRoot = process.cwd()
  projectBase = Path.basename(projectRoot)

  # Include Jade
  Jade = require('../lib/jade')

  # Include Yaml with Glob, Formats and Trimming
  Yaml = require('../lib/yaml')
    .setProjectRoot(projectRoot)
    .setProjectBase(projectBase)
    .setGrunt(grunt)

  # Include Grunt Task Helper
  GruntTaskHelper = require('../lib/grunt/task_helper')
    .setProjectRoot(projectRoot)
    .setProjectBase(projectBase)
    .setGrunt(grunt)

  # Include custom file utilities
  File = require('../lib/file')

  grunt.registerMultiTask 'justjaded', 'Static Site Generator.', ->
    options = this.options
      # Project
      buildDir: projectRoot
      assetDir: 'assets'
      # Jade
      jadeFilters: {}
      jadeOptions: {}
      jadeData:    {}
      jadeInit: -> {}
      # Generic
      pretty: true
      debug: false

    # Resolve the asset dir location
    options.assetDir = File.resolve(options.assetDir, options.buildDir)

    # Read the source files with Grunt
    options.gruntReadSourceFiles = true

    # Create a new Task Helper
    task = new GruntTaskHelper(@, options)

    # Start processing files
    task.forFiles 'jade', (file, dest) ->

      if file.type is 'jade'

        # Yaml Config File Locations...
        yamlDir  = file.name.replace(/^(.*)(jade!?)(.*)$/gi, '$1yaml')
        yamlName = File.resolve(dest.name, yamlDir)
        yamlPath = yamlName.concat('.yaml')
        yamlData = Yaml.loadFile(yamlPath)

        # Load Jade Template Engine
        @jade = Jade.setGrunt(grunt).init(@jade)

        # Prepare Jade; sets @jadeOptions, @jadeData
        Jade.prep.call(@, options, file, dest, yamlData)

        return @jade.compile(file.data, @jadeOptions)(@jadeData)
