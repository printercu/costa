module.exports =
class ActionController extends require './request_controller'
  @extendsWithProto()

  @includeAll module, prefix: './',
    'connect'
    'callbacks'

  @abstract: true
