cs      = require 'coffee-script'
_       = require 'underscore'
lingo   = require 'lingo'
Args    = require '../support/args'

module.exports =
class Callbacks extends require('coffee_classkit').Module
  @extendsWithProto().concern()

  @include require '../support/callbacks'

  class @ClassMethods
    defineModelCallbacks: ->
      [options, actions] = Args.findOptions arguments
      options = _.extend
        only: ['before', 'after']
        options
      for action in actions
        for type in options.only
          @defineCallbacks action, type
          @[lingo.camelcase "#{type} #{action}"] = eval cs.compile """
            -> @setCallback '#{action}', '#{type}', arguments...
          """, bare: true
        @[lingo.camelcase("around #{action}")] =
          @[lingo.camelcase("before #{action}")]

  @includedBlock = ->
    @defineModelCallbacks 'create', 'update', 'save', 'destroy'

    @aliasMethodChain method, 'callbacks' for method in [
      'save'
      '_createRecord'
      '_updateRecord'
      'destroy'
    ]
  # instance methods
  callbacks_and_methods =
    save:     'save'
    destroy:  'destroy'
    create:   '_createRecord'
    update:   '_updateRecord'

  # Here methods that receives only one argument are supported.
  for type, method of callbacks_and_methods
    @::["#{method}WithCallbacks"] = eval cs.compile """
      (callback) ->
        results = null
        @runCallbacks '#{type}',
          (_..., flow) -> @#{method}WithoutCallbacks (err) ->
            results = arguments
            flow err
          error:  -> callback?.apply @, arguments
          final:  -> callback?.apply @, results
    """, bare: true
