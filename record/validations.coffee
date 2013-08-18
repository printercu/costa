_       = require 'underscore'
Args    = require '../support/args'

Errors  = require './errors'

module.exports =
class Validations extends require('coffee_classkit').Module
  @extendsWithProto().concern()

  @includedBlock = ->
    @defineModelCallbacks 'validation'
    @defineCallbacks 'validate'

  class @ClassMethods
    validate: ->
      [options, filter] = normalize_options arguments
      @setCallback 'validate', 'before', options, filter
      @

    # private helpers
    normalize_options = (args) ->
      [options, [filter]] = Args.findOptions args
      if options.on
        on_clauses = for mode in _.flatten [options.on]
          "@_validation_context is '#{mode}'"
        options.if = _.flatten _.compact [options.if].concat [on_clauses.join ' or ']
      [
        if:     options.if
        unless: options.unless
        when:   options.when
        filter
      ]

  Object.defineProperty @::, 'errors', get: -> @_errors ||= new Errors @

  runValidations: (args..., callback) ->
    @errors.clear()
    @isValid  = false
    err_cb    = (err) -> callback?.call @, err, @isValid
    @runCallbacks 'validation',
      ->
        @_validation_context = if @_isPersisted then 'update' else 'create'
        @runCallbacks 'validate',
          ->
            @isValid = !@errors.hasAny()
            callback?.call @, null, @isValid
          err_cb
      err_cb
    @

fs    = require 'fs'
path  = require 'path'
dir   = "#{__dirname}/validations"
for file in fs.readdirSync dir
  continue unless /.(js|coffee)$/.test file
  Validations.include require path.join dir, file
