// Generated by CoffeeScript 1.6.3
(function() {
  var Args, Errors, Validations, dir, file, fs, path, _, _i, _len, _ref, _ref1,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __slice = [].slice;

  _ = require('underscore');

  Args = require('../support/args');

  Errors = require('./errors');

  module.exports = Validations = (function(_super) {
    __extends(Validations, _super);

    function Validations() {
      _ref = Validations.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    Validations.extendsWithProto().concern();

    Validations.includedBlock = function() {
      this.defineModelCallbacks('validation');
      return this.defineCallbacks('validate');
    };

    Validations.ClassMethods = (function() {
      var normalize_options;

      function ClassMethods() {}

      ClassMethods.prototype.validate = function() {
        var filter, options, _ref1;
        _ref1 = normalize_options(arguments), options = _ref1[0], filter = _ref1[1];
        this.setCallback('validate', 'before', options, filter);
        return this;
      };

      normalize_options = function(args) {
        var filter, mode, on_clauses, options, _ref1, _ref2;
        _ref1 = Args.findOptions(args), options = _ref1[0], (_ref2 = _ref1[1], filter = _ref2[0]);
        if (options.on) {
          on_clauses = (function() {
            var _i, _len, _ref3, _results;
            _ref3 = _.flatten([options.on]);
            _results = [];
            for (_i = 0, _len = _ref3.length; _i < _len; _i++) {
              mode = _ref3[_i];
              _results.push("@_validation_context is '" + mode + "'");
            }
            return _results;
          })();
          options["if"] = _.flatten(_.compact([options["if"]].concat([on_clauses.join(' or ')])));
        }
        return [
          {
            "if": options["if"],
            unless: options.unless,
            when: options.when
          }, filter
        ];
      };

      return ClassMethods;

    })();

    Object.defineProperty(Validations.prototype, 'errors', {
      get: function() {
        return this._errors || (this._errors = new Errors(this));
      }
    });

    Validations.prototype.runValidations = function() {
      var args, callback, err_cb, _i;
      args = 2 <= arguments.length ? __slice.call(arguments, 0, _i = arguments.length - 1) : (_i = 0, []), callback = arguments[_i++];
      this.errors.clear();
      this.isValid = false;
      err_cb = function(err) {
        return callback != null ? callback.call(this, err, this.isValid) : void 0;
      };
      this.runCallbacks('validation', function() {
        this._validation_context = this._isPersisted ? 'update' : 'create';
        return this.runCallbacks('validate', function() {
          this.isValid = !this.errors.hasAny();
          return callback != null ? callback.call(this, null, this.isValid) : void 0;
        }, err_cb);
      }, err_cb);
      return this;
    };

    return Validations;

  })(require('coffee_classkit').Module);

  fs = require('fs');

  path = require('path');

  dir = "" + __dirname + "/validations";

  _ref1 = fs.readdirSync(dir);
  for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
    file = _ref1[_i];
    if (!/.(js|coffee)$/.test(file)) {
      continue;
    }
    Validations.include(require(path.join(dir, file)));
  }

}).call(this);