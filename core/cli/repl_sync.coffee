# UNSTABLE. For debug use only
Fiber = require 'fibers'
Sync  = require 'sync'

debug = require('debug') 'sync'

module.exports = (app, repl) ->
  for name, klass of app.models
    synchronizeObj klass
    synchronizeObj klass::

  old_eval = repl.eval
  repl.eval = (args...) -> Fiber(-> old_eval args...).run()

  console.log '*REPL is running in sync mode*'
  repl.displayPrompt()

synchronizeObj = (klass) ->
  method_prefix = if typeof klass is 'function'
    "#{klass.name}."
  else
    "#{klass.constructor.name}::"
  for method in Object.getOwnPropertyNames klass
    desctiptor = Object.getOwnPropertyDescriptor klass, method
    continue unless typeof desctiptor.value is 'function'
    continue if /Sync$/.test method
    continue if klass["#{method}Sync"]?
    debug "#{method_prefix}#{method}"
    do (method) ->
      Object.defineProperty klass, "#{method}Sync", value: ->
        klass[method].sync @, arguments...
  synchronizeObj klass.__proto__ if klass.__proto__
