# grunt-jaded
# http://kellybecker.me
#
# Copyright (c) 2014 Kelly Becker
# Licensed under the MIT license.
'use strict'

class YamlTrimHelpers
  @null: (data) ->
    data is 'undefined' || \
    data is null

  @empty: (data) ->
    @null(data) || \
    data.length < 1

module.exports = class YamlTrim

  @resolveTrim: (data, parent) ->
    for key, value of data when YamlTrimHelpers.null(value)
      if data instanceof Array
        data.splice(key, 1)
      else
        delete data[key]

    return data
