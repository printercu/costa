// Generated by CoffeeScript 1.6.3
(function() {
  var Args, EachSync, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Args = require('../../support/args');

  module.exports = EachSync = (function(_super) {
    __extends(EachSync, _super);

    function EachSync() {
      _ref = EachSync.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    EachSync.extendsWithProto().concern();

    EachSync.ClassMethods = (function() {
      function ClassMethods() {}

      ClassMethods.prototype.validatesEachSync = function(args, validator) {
        var fields, options, _ref1;
        _ref1 = Args.findOptions(args), options = _ref1[0], fields = _ref1[1];
        return this.validate(options, function(callback) {
          var field, _i, _len;
          for (_i = 0, _len = fields.length; _i < _len; _i++) {
            field = fields[_i];
            validator.call(this, field, options);
          }
          return callback(null);
        });
      };

      return ClassMethods;

    })();

    return EachSync;

  })(require('coffee_classkit').Module);

}).call(this);