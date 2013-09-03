programm = require 'commander'
programm
  .version(require('../package').version)
  .option('-e, --env <env>',            'Set environment')
  .option('-L, --no-listen',            'Do not start server')
  .option('-P, --port <port>',          'Port or socket path to listen on')
  .option('-c, --cluster',              'Run cluster')
  .option('-i, --interactive [mode]',   'Enable console')
  .option('-S, --no-sync',              'Do not create sync functions in console')
  .option('-p, --pid <file>',           'Pid file')
  .parse(process.argv)

process.env.NODE_ENV  = programm.env  if programm.env
process.env.PORT      = programm.port if programm.port

fs    = require 'fs'
path  = require 'path'
app_file = 'etc/application.coffee'
find_root = ->
  dir = process.cwd()
  while dir.length > 1
    return dir if fs.existsSync path.join dir, app_file
    dir = path.resolve dir, '../'
  false

root = find_root()
require cli_file unless root

if programm.cluster
  if master = require('cluster_master').runMaster(pidfile: programm.pid)
    if programm.interactive
      require('./cli/repl') programm,
        master:   master
        cluster:  require 'cluster'
    return

Application = require "#{root}/etc/application"
app = new Application(root: root)
app.initialize (err) ->
  if err
    console.error 'Init failed: %s', err
    process.exit -1

  if programm.listen
    process.on 'SIGINT', -> process.exit()
    @server = @listen @settings.port, =>
      console.log '%d: Listening on %s in %s mode',
        process.pid, @settings.port, @settings.env
      programm.repl?.displayPrompt()
    process.on 'exit', =>
      @server.close().unref() if @server._handle # undocumented

  if programm.interactive && !programm.cluster
    require('./cli/repl') programm, app: @
