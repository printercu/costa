module.exports = (programm, context = {}) ->
  type = if programm.interactive is true then 'coffee' else programm.interactive
  programm.repl = repl = (switch type
    when 'node' then require 'repl'
    else require 'coffee-script/lib/coffee-script/repl'
  ).start
    prompt: "eve@#{type}> "
  .on 'exit', ->
    app.server.close().unref() if app?.server?._handle # undocumented
    process.emit 'close'

  repl.context.programm = programm
  repl.context[key] = val for key, val of context
  if app = context.app
    for type in ['models', 'controllers']
      for key, val of app[type]
        repl.context[key] = val
    require('./repl_sync') app, repl if programm.sync

  if process.env.HOME
    try require('repl.history') repl, "#{process.env.HOME}/.node_history"
