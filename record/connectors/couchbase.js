// Generated by CoffeeScript 1.6.3
(function() {
  var Couchbase, debug, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  debug = require('debug')('record:connector:couchbase');

  module.exports = Couchbase = (function(_super) {
    __extends(Couchbase, _super);

    function Couchbase() {
      _ref = Couchbase.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    Couchbase.extendsWithProto().concern();

    Couchbase.ClassMethods = (function() {
      function ClassMethods() {}

      ClassMethods.prototype.get = function(id, callback) {
        var _this = this;
        debug("GET: " + id);
        return this.kv.get(this._key(id), function(err, item) {
          debug("GOT: " + id);
          if (err) {
            return typeof callback === "function" ? callback(err) : void 0;
          }
          item.__proto__ = _this.prototype;
          return typeof callback === "function" ? callback(null, item) : void 0;
        });
      };

      ClassMethods.prototype.set = function(id, data, callback) {
        return this.kv.set(this._key(id), data, callback);
      };

      ClassMethods.prototype.getMulti = function(ids, callback) {
        var _this = this;
        if (!ids.length) {
          return setImmediate(function() {
            return callback(null, {});
          });
        }
        this.kv.get_multi(ids, function(err, items) {
          var item, result, _i, _len;
          if (err) {
            return typeof callback === "function" ? callback(err) : void 0;
          }
          result = {};
          for (_i = 0, _len = items.length; _i < _len; _i++) {
            item = items[_i];
            item.__proto__ = _this.prototype;
            result[item.id] = item;
          }
          return typeof callback === "function" ? callback(null, result) : void 0;
        });
        return this;
      };

      return ClassMethods;

    })();

    return Couchbase;

  })(require('coffee_classkit').Module);

}).call(this);