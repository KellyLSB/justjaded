# grunt-jaded
# http://kellybecker.me
#
# Copyright (c) 2014 Kelly Becker
# Licensed under the MIT license.
'use strict'

# Required Lib.
JadeGlobInclude = require('jade-glob-include')
Extend          = require('coffee-script').helpers.extend
Merge           = require('coffee-script').helpers.merge
Chalk           = require('chalk')
Jade            = require('jade')

# Local Lib.
Module          = require('./module')
File            = require('./file')

module.exports = class Jade extends Module

  @init: (@jade) ->
    @jade ||= require('jade')
    JadeGlobInclude.patch(@jade)


  @jadeData: (args) ->
    data = args['options'].jadeData
    if data is 'function'
      data = data.call(@, args['file'], args['dest'])
    if ! data is 'object' then data = {}
    @jadeData = Merge(data, args['data']...)


  @jadeFilters: (options) ->
    if options.jadeFilters
      for filter, func of options.jadeFilters
        @jade.filters[filter] = func.bind(@)


  @jadeOptions: (args) ->
    options = args['options']

    if typeof options.jadeInit is 'function'
      options.jadeInit.call(@jadeData)

    @jadeOptions =
      compileDebug: options.debug
      filename: args['file'].path
      pretty: options.pretty
