classkit  = require 'coffee_classkit'

module.exports =
class Uniquiness extends require('coffee_classkit').Module
  @extendsWithProto().concern()

  class @ClassMethods
    validatesUniquinessOf: ->
      throw new Error 'not implemented'
      [options, fields] = classkit.findOptions arguments
      @validate options, (callback) ->
        for field in fields
          @errors.add field, 'Should be present' unless @[field]?
        callback null
