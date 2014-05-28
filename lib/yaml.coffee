# grunt-jaded
# http://kellybecker.me
#
# Copyright (c) 2014 Kelly Becker
# Licensed under the MIT license.
'use strict'


# Module Support
# I am including this externally as it as
# I won't be able to extend against it otherwise
Module = require('grunt-tusks').Library.Module


# YAML Processor Libraries
YamlGlob     = require('./yaml/glob')
YamlIncludes = require('./yaml/includes')
YamlFormats  = require('./yaml/formats')
YamlTrim     = require('./yaml/trim')


module.exports = class Yaml extends Module
  @extend YamlGlob
  @extend YamlIncludes
  @extend YamlFormats
  @extend YamlTrim


  @loadFile: (file) ->
    if data = @File.read(file)
      @grunt.log.writeln "Reading data file " \
        + "\"#{@Chalk.cyan(file)}\"."

      # Parse YAML
      data = @JsYaml.safeLoad(data)

      # Post Process Hashes
      data = @resolveIncludes(data, file)
      data = @resolveFormats(data, file)
      data = @resolveTrim(data, file)
      return data

    @grunt.log.warn "Data file " \
      + "\"#{@Chalk.cyan(file)}}\"  not found."

    return false
