fs    = require 'fs'
path  = require 'path'
flow  = require 'flow-coffee'
lingo = require 'lingo'

module.exports =
class Initialization extends require('coffee_classkit').Module
  @extendsWithProto().concern()

  initialize: (callback) ->
    final_cb = (err) => callback?.call @, err

    require("#{@root}/etc/env").call @

    do new flow
      context:  @
      error:    final_cb
      final:    -> final_cb null
      blocks:   @initBlocks
    @

  autoload: (callback) ->
    dirs =
      'app/models':       'models'
      'app/controllers':  'controllers'
    for rel_dir, target of dirs
      dir = path.join @root, rel_dir
      @[target] = {}
      files = try
          fs.readdirSync dir
        catch e
          []
      for file in files
        continue unless /.(js|coffee)$/.test file
        class_name = path.basename(file, path.extname file).replace /_/g, ' '
        class_name = lingo.camelcase class_name, true
        @[target][class_name] = require path.join dir, file
    callback()

  loadInitializers: (callback) ->
    app = @
    dir = "#{@root}/etc/init"
    flow.exec(
      ->
        @expectMulti()
        for file in fs.readdirSync dir
          continue unless /.(js|coffee)$/.test file
          func = require(path.join dir, file)
          continue unless func.call?
          arg = if func.length then @multi() else null
          func.call app, arg
      (err) -> callback err
    )

  initGlobals: (callback) ->
    try require("#{@root}/etc/globals")
    callback()

  initMiddleware: (callback) ->
    require("#{@root}/etc/middleware").call @, (err) -> callback err
