// Generated by CoffeeScript 1.6.3
(function() {
  var Application, app, app_file, find_root, fs, master, path, programm, root;

  programm = require('commander');

  programm.version(require('../package').version).option('-e, --env <env>', 'Set environment').option('-L, --no-listen', 'Do not start server').option('-P, --port <port>', 'Port or socket path to listen on').option('-c, --cluster', 'Run cluster').option('-i, --interactive [mode]', 'Enable console').option('-S, --no-sync', 'Do not create sync functions in console').option('-p, --pid <file>', 'Pid file').parse(process.argv);

  if (programm.env) {
    process.env.NODE_ENV = programm.env;
  }

  if (programm.port) {
    process.env.PORT = programm.port;
  }

  fs = require('fs');

  path = require('path');

  app_file = 'etc/application.coffee';

  find_root = function() {
    var dir;
    dir = process.cwd();
    while (dir.length > 1) {
      if (fs.existsSync(path.join(dir, app_file))) {
        return dir;
      }
      dir = path.resolve(dir, '../');
    }
    return false;
  };

  root = find_root();

  if (!root) {
    require(app_file);
  }

  if (programm.cluster) {
    if (master = require('cluster_master').runMaster({
      pidfile: programm.pid
    })) {
      if (programm.interactive) {
        require('./cli/repl')(programm, {
          master: master,
          cluster: require('cluster')
        });
      }
      return;
    }
  }

  Application = require("" + root + "/" + app_file);

  app = new Application({
    root: root
  });

  app.initialize(function(err) {
    var _this = this;
    if (err) {
      console.error('Init failed: %s', err);
      process.exit(-1);
    }
    if (programm.listen) {
      process.on('SIGINT', function() {
        return process.exit();
      });
      this.server = this.listen(this.settings.port, function() {
        var _ref;
        console.log('%d: Listening on %s in %s mode', process.pid, _this.settings.port, _this.settings.env);
        return (_ref = programm.repl) != null ? _ref.displayPrompt() : void 0;
      });
      process.on('exit', function() {
        if (_this.server._handle) {
          return _this.server.close().unref();
        }
      });
    }
    if (programm.interactive && !programm.cluster) {
      return require('./cli/repl')(programm, {
        app: this
      });
    }
  });

}).call(this);
