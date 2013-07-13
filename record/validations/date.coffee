classkit  = require 'coffee_classkit'
util      = require 'util'

module.exports =
class DateFormat extends require('coffee_classkit').Module
  @extendsWithProto().concern()

  class @ClassMethods
    validatesDateFormatOf: ->
      [options, fields] = classkit.findOptions arguments
      @validate options, (callback) ->
        for field in fields
          date = @[field]
          continue if options.allowNull and !date?
          unless util.isDate date
            date = new Date date
          if isFinite date
            @[field] = date
          else
            @errors.add field, options.message || 'Invalid date format'
        callback null
