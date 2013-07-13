classkit  = require 'coffee_classkit'

module.exports =
class Confirmation extends require('coffee_classkit').Module
  @extendsWithProto().concern()

  class @ClassMethods
    validatesConfirmationOf: ->
      [options, fields] = classkit.findOptions arguments
      @validate options, (callback) ->
        for field in fields
          value = @[field]
          continue if options.allowNull and !value?
          continue if options.allowBlank and !value
          if (value_confirm = @["#{field}_confirmation"])?
            unless value_confirm == value
              @errors.add field, 'Confirmation does not match'
          else
            @errors.add field, 'No confirmation'
        callback null
