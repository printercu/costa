module.exports =
class Confirmation extends require('coffee_classkit').Module
  @extendsWithProto().concern()

  class @ClassMethods
    validatesConfirmationOf: ->
      @validatesEachSync arguments, (field, options) ->
        value = @[field]
        return if options.allowNull and !value?
        return if options.allowBlank and !value
        if (value_confirm = @["#{field}_confirmation"])?
          unless value_confirm == value
            @errors.add field, 'Confirmation does not match'
        else
          @errors.add field, 'No confirmation'
