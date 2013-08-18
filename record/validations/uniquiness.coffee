module.exports =
class Uniquiness extends require('coffee_classkit').Module
  @extendsWithProto().concern()

  class @ClassMethods
    validatesUniquinessOf: ->
      throw new Error 'not implemented'
      @validatesEachSync arguments, (field, options) ->
        @errors.add field, 'Should be present' unless @[field]?
