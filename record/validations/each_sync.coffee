classkit  = require 'coffee_classkit'

module.exports =
class EachSync extends require('coffee_classkit').Module
  @extendsWithProto().concern()

  class @ClassMethods
    validatesEachSync: (args, validator) ->
      [options, fields] = classkit.findOptions args
      @validate options, (callback) ->
        for field in fields
          validator.call @, field, options
        callback null
