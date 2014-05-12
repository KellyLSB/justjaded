# grunt-jaded
# http://kellybecker.me
#
# Copyright (c) 2014 Kelly Becker
# Licensed under the MIT license.
'use strict'

# Required Lib.
Chalk        = require('chalk')

# Local Lib.
Module       = require('../module')
File         = require('../file')

module.exports = $ = class GruntTaskHelper extends Module

  @setProjectRoot: (@projectRoot) -> @
  @setProjectBase: (@projectBase) -> @

  @setGrunt: (@grunt) -> @

  @taskForFiles: (options, cb) ->
    @files.forEach (f) =>
      f.orig.output = output = []

      # Destination File Information
      dest =
        type: File.type(f.dest)
        name: File.fullname(options.buildDir, f.dest)
        path: File.resolve(f.dest, options.buildDir)

      # Dest path relative to the project root
      dest['relative'] = File.relative(dest.path)

      # Remove any sources that do not exist and loop.
      f.src.filter($.filterFiles).forEach (filepath) =>

        # Source File Information
        file =
          type: File.type(filepath)
          name: File.fullname(filepath)
          path: File.resolve(filepath)
          data: $.grunt.file.read(filepath)

        # Process file and push output
        try
          output.push(cb.call(f.orig, file, dest))
        catch e
          $.grunt.log.warn("Failed to process \"#{filepath}\".")
          $.grunt.log.error(e)

      # Filter output by removing non string values
      output = output.filter (data) -> typeof data is 'string'

      if output.length < 1
        # No resulting outputted data to save...
        $.grunt.log.warn "Destination \"#{Chalk.cyan(dest.relative)}\" not " \
          + "written: Processed files returned empty results."
      else
        # Join and normalize the output
        @options.seperator ||= $.grunt.util.linefeed.repeat(2)
        output = output.join(@options.seperator)
        output = $.grunt.util.normalizelf(output)

        # Write the output to a file
        $.grunt.file.write(dest.relative, output)
        $.grunt.log.writeln "File \"#{Chalk.cyan(dest.relative)}\" created."

  @filterFiles: (filepath) ->
    if ! $.grunt.file.exists(filepath)
      $.grunt.log.warn("Source file \"#{filepath}\" not found.")
      return false
    else true
