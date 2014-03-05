_         = require 'underscore'
lingo     = require 'lingo'
classkit  = require 'coffee_classkit'
Args      = require '../support/args'

module.exports =
class Callbacks extends require('coffee_classkit').Module
  @extendsWithProto().concern()

  @include require '../support/callbacks'

  @includedBlock = ->
    @defineCallbacks 'process'
    @aliasMethodChain '_processAction', 'callbacks'

  class @ClassMethods
    ['before', 'after'].forEach (type) =>
      @::["#{type}Filter"] = ->
        [options, filter] = normalize_args arguments
        @setCallback 'process', type, options, filter

      @::[lingo.camelcase "skip #{type} filter"] = ->
        [options, filter] = normalize_args arguments
        @skipCallback 'process', type, options, filter
    # use it to show that this callback is using _flow.after_
    classkit.aliasMethod @, 'aroundFilter', 'beforeFilter'
    classkit.aliasMethod @, 'skipAroundFilter', 'skipBeforeFilter'

    normalize_args = (args) ->
      [options, [filter]] = Args.findOptions args
      [
        if:     normalize_option options.only
        unless: normalize_option options.except
        when:   options.when
        filter
      ]

    normalize_option = (options) ->
      ("@actionName is '#{action}'" for action in _.compact _.flatten [options])
        .join ' or '

  # Replaces @next with flow callback. Use @_next to access original callback.
  _processActionWithCallbacks: ->
    @_original_next = @next
    do @next = @prepareCallbacks 'process',
      @_processActionWithoutCallbacks
      @_next = ->
        @next = @_original_next
        @_original_next = null
        @next arguments...
