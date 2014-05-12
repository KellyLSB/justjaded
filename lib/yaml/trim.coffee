# grunt-jaded
# http://kellybecker.me
#
# Copyright (c) 2014 Kelly Becker
# Licensed under the MIT license.
'use strict'

module.exports = class YamlTrim

  @resolveTrim: (data, parent) ->
    isArray = data instanceof Array
    delKeys = []

    for key, value of data
      if typeof value is 'object'
        data[key] = @resolveTrim(value, parent)
      if data[key] is null || value is null
        delKeys.push(key)

    for key in delKeys.sort((a,b) -> b-a)
      if isArray then data.splice(key, 1)
      else delete data[key]

    return data
