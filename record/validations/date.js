// Generated by CoffeeScript 1.6.3
(function() {
  var DateFormat, util, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  util = require('util');

  module.exports = DateFormat = (function(_super) {
    __extends(DateFormat, _super);

    function DateFormat() {
      _ref = DateFormat.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    DateFormat.extendsWithProto().concern();

    DateFormat.ClassMethods = (function() {
      function ClassMethods() {}

      ClassMethods.prototype.validatesDateFormatOf = function() {
        return this.validatesEachSync(arguments, function(field, options) {
          var date;
          date = this[field];
          if (options.allowNull && (date == null)) {
            return;
          }
          if (!util.isDate(date)) {
            date = new Date(date);
          }
          if (isFinite(date)) {
            return this[field] = date;
          } else {
            return this.errors.add(field, options.message || 'Invalid date format');
          }
        });
      };

      return ClassMethods;

    })();

    return DateFormat;

  })(require('coffee_classkit').Module);

}).call(this);
