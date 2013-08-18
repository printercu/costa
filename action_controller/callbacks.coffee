cs        = require 'coffee-script'
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
    @aliasMethodChain 'process', 'callbacks'

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
      ("@action is '#{action}'" for action in _.compact _.flatten [options])
        .join ' or '

  processWithCallbacks: (method, callback) ->
    @runCallbacks 'process',
      (flow) -> @processWithoutCallbacks method, flow
      callback
