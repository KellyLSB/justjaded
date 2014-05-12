# grunt-jaded
# http://kellybecker.me
#
# Copyright (c) 2014 Kelly Becker
# Licensed under the MIT license.
'use strict'

$ = class YamlFormatsHelpers

  @except: (data, format) ->
    if typeof data is 'object' && !(typeof data['except!'] is 'undefined')
      !(format is data['except!'] || format in data['except!'])
    else true

  @only: (data, format) ->
    if typeof data is 'object' && !(typeof data['only!'] is 'undefined')
      (format is data['only!'] || format in data['only!'])
    else true

module.exports = class YamlFormats

  @resolveFormats: (data, parent, format) ->

    format ||= data['format!']
    if ! format then return data

    unless $.only(data, format) && \
           $.except(data, format)

      return null

    for key, value of data when typeof value is 'object'
      data[key] = if value["#{format}!"]
        if value["#{format}!"] is 'object'
          @resolveFormats(value["#{format}!"], parent, format)
        else value["#{format}!"]
      else @resolveFormats(value, parent, format)

    return data
