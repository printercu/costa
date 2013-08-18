module.exports =
class Presence extends require('coffee_classkit').Module
  @extendsWithProto().concern()

  class @ClassMethods
    validatesPresenceOf: ->
      @validatesEachSync arguments, (field, options) ->
        value = @[field]
        unless value || value? && options.allowBlank
          @errors.add field, options.message || 'Should be present'
