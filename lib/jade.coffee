# grunt-jaded
# http://kellybecker.me
#
# Copyright (c) 2014 Kelly Becker
# Licensed under the MIT license.
'use strict'


module.exports = $ = class Jade

  @jadeGlobInclude: require('jade-glob-include')
  @instance: require('jade')


  @onTusksInit: ->
    @jadeGlobInclude.patch(@instance)


  @prep: (file, dest, extraData...) ->
    data = @options.jadeData
    @jadeData = {}

    # If data is a function call it on @jadeData
    if data && typeof data is 'function'
      data = data.call(@jadeData, file, dest)

    # If the data is an object (not an Array) push the data on
    if data && typeof data is 'object' && \
        !(data instanceof Array)
      @Extend(@jadeData, data)

    # Extend additional data in from Yaml or other sources
    for extra in extraData when typeof extra is 'object' && \
        ! (extra instanceof Array)
      @Extend(@jadeData, extra)

    # Build Config Hash
    @jadeData.config =

      # AssetDir relative to
      # Destination File
      assetDir:
        @File.relative dest.dir,
        @options.assetDir,
        @options.buildDir

      # Timestamp when the
      # generation process ran
      timestamp: @grunt.template.today()

      # File format if one was applied
      format: @jadeData['format!'] || null

    # Merge in the JadeFilters
    if @options.jadeFilters && \
        typeof @options.jadeFilters is 'object'

      for filter, func of @options.jadeFilters when \
          typeof func is 'function'
        @Jade.instance.filters[filter] = func.bind(@jadeData)

    # Declare the JadeOptions
    @jadeOptions =
      compileDebug: @options.debug
      pretty: @options.pretty
      filename: file.path

    # Run the JadeInit function if there is one
    if @options.jadeInit && \
        typeof @options.jadeInit is 'function'
      @options.jadeInit.call(@jadeData, file, dest)


  # Compile shortcut
  @compile: (args...) -> @instance.compile(args...)
