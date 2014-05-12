# grunt-jaded
# http://kellybecker.me
#
# Copyright (c) 2014 Kelly Becker
# Licensed under the MIT license.
'use strict'

module.exports = class YamlIncludes

  @resolveIncludes: (data, parent) ->
    for key, value of data
      if typeof value is 'object'
        data[key] = @resolveIncludes(value, parent)
      else if typeof value is 'string' && \
              match = value.match(/^include\ (.*)$/)
        data[key] = @loadGlob(match[1], parent)

    return data
