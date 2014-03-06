// Generated by CoffeeScript 1.6.3
(function() {
  var Responder,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  module.exports = Responder = (function(_super) {
    __extends(Responder, _super);

    Responder.extendsWithProto();

    Responder.delegate('render', 'redirectTo', {
      to: 'controller'
    });

    function Responder(controller, resources, options) {
      this.controller = controller;
      this.resources = resources;
      this.options = options;
      this.request = this.controller.request;
      this.format = this.controller.format;
    }

    Responder.prototype.respond = function(callback) {};

    return Responder;

  })(require('coffee_classkit').Module);

}).call(this);
