# grunt-jaded
# http://kellybecker.me
#
# Copyright (c) 2014 Kelly Becker
# Licensed under the MIT license.
'use strict'

# Required Lib.
JadeGlobInclude = require('jade-glob-include')
Extend          = require('coffee-script').helpers.extend
Merge           = require('coffee-script').helpers.merge
Chalk           = require('chalk')
Jade            = require('jade')

# Local Lib.
File            = require('./file')

module.exports = $ = class Jade
  @setGrunt: (@grunt) -> @


  @init: (@jade) ->
    @jade ||= require('jade')
    JadeGlobInclude.patch(@jade)


  @prep: (options, file, dest, extraData...) ->
    data = options.jadeData
    @jadeData = {}

    # If data is a function call it on @jadeData
    if data && typeof data is 'function'
      data = data.call(@jadeData, file, dest)

    # If the data is an object (not an Array) push the data on
    if data && typeof data is 'object' && \
       !(data instanceof Array)
      Extend(@jadeData, data)

    # Extend additional data in from Yaml or other sources
    Extend(@jadeData, extra) for extra in extraData

    # Build Config Hash
    @jadeData.config =

      # AssetDir relative to
      # Destination File
      assetDir:
        File.relative dest.dir,
        options.assetDir,
        options.buildDir

      # Timestamp when the
      # generation process ran
      timestamp:
        $.grunt.template.today()

      # File format if one was applied
      format: @jadeData['format!'] || null

    # Merge in the JadeFilters
    if options.jadeFilters && typeof options.jadeFilters is 'object'
      for filter, func of options.jadeFilters when typeof func is 'function'
        @jade.filters[filter] = func.bind(@jadeData)

    # Declare the JadeOptions
    @jadeOptions =
      compileDebug: options.debug
      pretty: options.pretty
      filename: file.path

    # Run the JadeInit function if there is one
    if options.jadeInit && typeof options.jadeInit is 'function'
      options.jadeInit.call(@jadeData, file, dest)
