# grunt-jaded
# http://kellybecker.me
#
# Copyright (c) 2014 Kelly Becker
# Licensed under the MIT license.
'use strict'

# Required Lib.
JsYaml       = require('js-yaml')
Chalk        = require('chalk')

# Local Lib.
Module       = require('./module')
File         = require('./file')

# Yaml Lib.
YamlGlob     = require('./yaml/glob')
YamlIncludes = require('./yaml/includes')
YamlFormats  = require('./yaml/formats')
YamlTrim     = require('./yaml/trim')

module.exports = class Yaml extends Module
  @extend YamlGlob
  @extend YamlIncludes
  @extend YamlFormats
  @extend YamlTrim

  @setProjectRoot: (@projectRoot) -> @
  @setProjectBase: (@projectBase) -> @
  @setGrunt: (@grunt) -> @

  @loadFile: (file) ->
    if data = File.read(file)
      data = JsYaml.safeLoad(data)
      
      # console.info "Loading YAML File: \"#{Chalk.cyan(file)}\""

      # Post Process
      data = @resolveIncludes(data, file)
      data = @resolveFormats(data, file)
      data = @resolveTrim(data, file)
      return data

    # No File Found Error
    @grunt.log.warn "Source file \"#{Chalk.cyan(file)}}\" not found."
    return false
