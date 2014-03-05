module.exports =
class RequestController extends require './abstract_controller'
  @extendsWithProto()

  @abstract: true

  # As of there are all methods are public in js, here is convention about
  # action methods in controllers. Methods that  ends with `Action`
  # are permited action methods.
  #
  # This will invoke _indexAction_ method in controller's instance:
  #
  #   ExampleController.dispatch 'index', request, response, next
  #
  @dispatch: (action, request, response, next) ->
    method = action + 'Action'
    # unless method in @actionMethods
    unless method of @::
      err = if request?.app?.set('env') is 'development'
        new Error "Can not find action `#{action}` in `#{@name}`"
      else
        404 # not found
      next? err
      return false
    new @(request, response).process action, next

  constructor: (@request, @response) ->
