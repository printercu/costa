module.exports =
class Format extends require('coffee_classkit').Module
  @extendsWithProto().concern()

  class @ClassMethods
    validatesFormatOf: ->
      @validatesEachSync arguments, (field, options) ->
        value = @[field]
        return if options.allowNull and !value?
        return if options.allowBlank and !value
        if false == options.with?.test value
          @errors.add field, options.message || 'Invalid format'
        if options.without?.test value
          @errors.add field, options.message || 'Invalid format'
