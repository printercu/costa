// Generated by CoffeeScript 1.6.3
(function() {
  var KeyVal, flow, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __slice = [].slice;

  flow = require('flow-coffee');

  module.exports = KeyVal = (function(_super) {
    __extends(KeyVal, _super);

    function KeyVal() {
      _ref = KeyVal.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    KeyVal.extendsWithProto().concern();

    KeyVal.ClassMethods = (function() {
      function ClassMethods() {}

      Object.defineProperty(ClassMethods.prototype, 'kvPrefix', {
        get: function() {
          if (this.hasOwnProperty('_kvPrefix')) {
            return this._kvPrefix;
          }
          return this._kvPrefix = this.tableName;
        },
        set: function(val) {
          return this._kvPrefix = val;
        }
      });

      ClassMethods.prototype._key = function(id, index) {
        if (index) {
          return "" + this.kvPrefix + "#" + id + ":" + index;
        } else {
          return "" + this.kvPrefix + ":" + id;
        }
      };

      ClassMethods.prototype._keySeq = function(field) {
        return "" + this.kvPrefix + "_" + field + "_seq";
      };

      ClassMethods.prototype.findInBatches = function() {
        var batch_size, callback, fn, from, max_id, options, _arg, _i, _ref1;
        _arg = 3 <= arguments.length ? __slice.call(arguments, 0, _i = arguments.length - 2) : (_i = 0, []), fn = arguments[_i++], callback = arguments[_i++];
        options = _arg[0];
        options || (options = {});
        from = (_ref1 = options.start) != null ? _ref1 : 1;
        batch_size = options.batchSize || 1000;
        max_id = 0;
        new flow({
          context: this,
          error: function(err) {
            return typeof callback === "function" ? callback(err) : void 0;
          },
          blocks: [
            function(next) {
              return this.maxId(next);
            }, function(id_seq, next) {
              if (!(max_id = id_seq)) {
                return typeof callback === "function" ? callback(null) : void 0;
              }
              return next();
            }, function(next) {
              var ids, remain, to, _j, _results;
              remain = max_id - from;
              if (remain < 1) {
                return typeof callback === "function" ? callback(null) : void 0;
              }
              to = from + (Math.min(batch_size, remain));
              ids = (function() {
                _results = [];
                for (var _j = from; from <= to ? _j < to : _j > to; from <= to ? _j++ : _j--){ _results.push(_j); }
                return _results;
              }).apply(this);
              from = to;
              next.rewind();
              return this.getMulti(ids, function(err, items) {
                var item;
                if (err) {
                  return typeof callback === "function" ? callback(err) : void 0;
                }
                items = (function() {
                  var _k, _len, _results1;
                  _results1 = [];
                  for (_k = 0, _len = items.length; _k < _len; _k++) {
                    item = items[_k];
                    if (item) {
                      _results1.push(item);
                    }
                  }
                  return _results1;
                })();
                if (!items.length) {
                  return next();
                }
                return fn(items, function(err) {
                  if (err) {
                    return typeof callback === "function" ? callback(err) : void 0;
                  }
                  return next();
                });
              });
            }
          ]
        })();
        return this;
      };

      return ClassMethods;

    })();

    return KeyVal;

  }).call(this, require('coffee_classkit').Module);

}).call(this);
