# grunt-jaded
# http://kellybecker.me
#
# Copyright (c) 2014 Kelly Becker
# Licensed under the MIT license.
'use strict'


module.exports = class YamlIncludes

  @resolveIncludes: (data, parent) ->
    for key, value of data
      data[key] = if typeof value is 'object'
        @resolveIncludes(value, parent)
      else if typeof value is 'string' && \
          match = value.match(/^include\ (.*)$/)
        @loadGlob(match[1], parent)

    return data
