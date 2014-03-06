// Generated by CoffeeScript 1.6.3
(function() {
  var RequestController,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  module.exports = RequestController = (function(_super) {
    __extends(RequestController, _super);

    RequestController.extendsWithProto();

    RequestController.abstract = true;

    RequestController.dispatch = function(action, request, response, next) {
      var err, method, _ref;
      method = action + 'Action';
      if (!(method in this.prototype)) {
        err = (request != null ? (_ref = request.app) != null ? _ref.set('env') : void 0 : void 0) === 'development' ? new Error("Can not find action `" + action + "` in `" + this.name + "`") : 404;
        if (typeof next === "function") {
          next(err);
        }
        return false;
      }
      return new this(request, response).process(action, next);
    };

    function RequestController(request, response) {
      this.request = request;
      this.response = response;
    }

    return RequestController;

  })(require('./abstract_controller'));

}).call(this);
