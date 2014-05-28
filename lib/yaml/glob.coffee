# grunt-jaded
# http://kellybecker.me
#
# Copyright (c) 2014 Kelly Becker
# Licensed under the MIT license.
'use strict'


# Required Libraries
Fs   = require('fs')
Path = require('path')
Glob = require('glob')


$ = class YamlGlobHelpers

  @resolveGlob: (pattern, parent) ->
    pattern = if parent
      root = Path.dirname(parent)
      Path.resolve(root, pattern)
    else Path.resolve(pattern)

    pattern = Path.relative(process.cwd(), pattern)
    pattern = Path.normalize(pattern)

    Glob.sync(pattern).filter (f) ->
      f.match(/\.y[a]{0,1}ml$/) && Fs.existsSync(f)


module.exports = class YamlGlob

  @loadFiles: (pattern, parent) ->
    @loadGlob(pattern, parent)

  @loadGlob: (pattern, parent) ->
    files = $.resolveGlob(pattern, parent)
    (@loadFile(f) for f in files).filter (d) ->
      !(d is undefined || d is null)
