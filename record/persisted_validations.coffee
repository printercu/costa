module.exports =
class PersistedValidations extends require('coffee_classkit').Module
  @extendsWithProto().concern()

  @includedBlock = ->
    @aliasMethodChain 'save', 'validations'

  class @ClassMethods

  # instance methods
  saveWithValidations: (callback) ->
    @runValidations (err, isValid) ->
      return callback? err if err
      return callback? 'Record invalid' unless isValid
      @saveWithoutValidations callback
