// Generated by CoffeeScript 1.6.3
(function() {
  var Args, Callbacks, classkit, lingo, _, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  _ = require('underscore');

  lingo = require('lingo');

  classkit = require('coffee_classkit');

  Args = require('../support/args');

  module.exports = Callbacks = (function(_super) {
    __extends(Callbacks, _super);

    function Callbacks() {
      _ref = Callbacks.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    Callbacks.extendsWithProto().concern();

    Callbacks.include(require('../support/callbacks'));

    Callbacks.includedBlock = function() {
      this.defineCallbacks('process');
      return this.aliasMethodChain('_processAction', 'callbacks');
    };

    Callbacks.ClassMethods = (function() {
      var normalize_args, normalize_option,
        _this = this;

      function ClassMethods() {}

      ['before', 'after'].forEach(function(type) {
        ClassMethods.prototype["" + type + "Filter"] = function() {
          var filter, options, _ref1;
          _ref1 = normalize_args(arguments), options = _ref1[0], filter = _ref1[1];
          return this.setCallback('process', type, options, filter);
        };
        return ClassMethods.prototype[lingo.camelcase("skip " + type + " filter")] = function() {
          var filter, options, _ref1;
          _ref1 = normalize_args(arguments), options = _ref1[0], filter = _ref1[1];
          return this.skipCallback('process', type, options, filter);
        };
      });

      classkit.aliasMethod(ClassMethods, 'aroundFilter', 'beforeFilter');

      classkit.aliasMethod(ClassMethods, 'skipAroundFilter', 'skipBeforeFilter');

      normalize_args = function(args) {
        var filter, options, _ref1, _ref2;
        _ref1 = Args.findOptions(args), options = _ref1[0], (_ref2 = _ref1[1], filter = _ref2[0]);
        return [
          {
            "if": normalize_option(options.only),
            unless: normalize_option(options.except),
            when: options.when
          }, filter
        ];
      };

      normalize_option = function(options) {
        var action;
        return ((function() {
          var _i, _len, _ref1, _results;
          _ref1 = _.compact(_.flatten([options]));
          _results = [];
          for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
            action = _ref1[_i];
            _results.push("@actionName is '" + action + "'");
          }
          return _results;
        })()).join(' or ');
      };

      return ClassMethods;

    }).call(this);

    Callbacks.prototype._processActionWithCallbacks = function() {
      this._original_next = this.next;
      return (this.next = this.prepareCallbacks('process', this._processActionWithoutCallbacks, this._next = function() {
        this.next = this._original_next;
        this._original_next = null;
        return this.next.apply(this, arguments);
      }))();
    };

    return Callbacks;

  }).call(this, require('coffee_classkit').Module);

}).call(this);
