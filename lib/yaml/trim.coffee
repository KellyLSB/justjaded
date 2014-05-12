# grunt-jaded
# http://kellybecker.me
#
# Copyright (c) 2014 Kelly Becker
# Licensed under the MIT license.
'use strict'

$ = class YamlTrimHelpers
  
  @null: (data) -> typeof data is 'undefined' || data is null
  @empty: (data) -> @null(data) || data.length < 1
  @object: (data) -> typeof data is 'object'

module.exports = class YamlTrim

  @resolveTrim: (data, parent) ->
    for key, value of data

      if $.object(value)
        data[key] = value = @resolveTrim(value, parent)

      if $.null(value)
        if data instanceof Array then data.splice(key, 1)
        else delete data[key]

    return data
