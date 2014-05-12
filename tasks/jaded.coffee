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

  grunt.registerMultiTask 'jaded', 'Static Site Generator.', ->
    options = this.options
      # Project
      buildDir: projectRoot
      # Jade
      jadeFilters: {}
      jadeOptions: {}
      jadeData:    {}
      jadeInit: -> {}
      # Generic
      pretty: true
      debug: false

    GruntTaskHelper.taskForFiles.call @, options, (file, dest) ->

      if file.type is 'jade'

        # Yaml Config File Locations...
        yamlDir  = file.name.replace(/^(.*)(jade!?)(.*)$/gi, '$1yaml')
        yamlName = File.resolve(dest.name, yamlDir)
        yamlPath = yamlName.concat('.yaml')
        yamlData = Yaml.loadFile(yamlPath)

        # Load Jade Template Engine
        @jade = Jade.init(@jade)

        # Handle Loading the Jade Data
        Jade.jadeData.call @,
          options: options,
          data: [yamlData],
          file: file,
          dest: dest

        # Hande Loading the Jade Filters
        Jade.jadeFilters.call(@, options)

        # Handle all further Jade Options
        Jade.jadeOptions.call @,
          options: options,
          file: file,
          dest:dest

        source = @jade.compile(file.data, @jadeOptions)(@jadeData)
        grunt.log.writeln("File \"#{Chalk.cyan(dest.path)}\" created.")
        return source
