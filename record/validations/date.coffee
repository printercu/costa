util      = require 'util'

module.exports =
class DateFormat extends require('coffee_classkit').Module
  @extendsWithProto().concern()

  class @ClassMethods
    validatesDateFormatOf: ->
      @validatesEachSync arguments, (field, options) ->
        date = @[field]
        return if options.allowNull and !date?
        unless util.isDate date
          date = new Date date
        if isFinite date
          @[field] = date
        else
          @errors.add field, options.message || 'Invalid date format'
