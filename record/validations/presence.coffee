classkit  = require 'coffee_classkit'

module.exports =
class Presence extends require('coffee_classkit').Module
  @extendsWithProto().concern()

  class @ClassMethods
    validatesPresenceOf: ->
      [options, fields] = classkit.findOptions arguments
      @validate options, (callback) ->
        for field in fields
          value = @[field]
          unless value || value? && options.allowBlank
            @errors.add field, options.message || 'Should be present'
        callback null
