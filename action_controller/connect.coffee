module.exports =
class Connect extends require('coffee_classkit').Module
  @extendsWithProto().concern()

  # Use connect-compatible middleware in filters.
  #
  #   @beforeFilter only: 'index', @connectMiddleware require('connect').json()
  #
  class @ClassMethods
    connectMiddleware: (middleware) -> (callback) ->
      middleware @req, @res, (err) ->
        # force one argument
        callback err
