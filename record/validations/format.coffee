classkit  = require 'coffee_classkit'

module.exports =
class Format extends require('coffee_classkit').Module
  @extendsWithProto().concern()

  class @ClassMethods
    validatesFormatOf: ->
      [options, fields] = classkit.findOptions arguments
      @validate options, (callback) ->
        for field in fields
          value = @[field]
          continue if options.allowNull and !value?
          continue if options.allowBlank and !value
          if false == options.with?.test value
            @errors.add field, options.message || 'Invalid format'
          if options.without?.test value
            @errors.add field, options.message || 'Invalid format'
        callback null
