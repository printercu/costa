module.exports =
class AbstractController extends require('coffee_classkit').Module
  @extendsWithProto()

  @abstract: true

  # As of property lookup is much faster then search in array _actionMethods_
  # property is no longer in use in ActionController.
  # It's used in socket controller to bind actions.
  Object.defineProperty @, 'actionMethods', get: ->
    @hasOwnProperty('_actionMethods') && @_actionMethods ||
      @reloadActionMethods()

  @reloadActionMethods: ->
    klass = @
    @_actionMethods = [].concat.apply([],
      while klass && !(klass.hasOwnProperty('abstract') && klass.abstract)
        methods = Object.keys klass.prototype
        klass = klass.__super__?.constructor
        methods
    ).map((m) -> m.match(/^(.+)Action$/)?[1])
    .filter (m) -> m

  # Setups controller for action and performs action.
  # @next is used to access callback from any point of controller.
  process: (action, callback) ->
    @actionName = action
    @next = callback
    @_processAction()

  # Call the action. Override this in a subclass to modify the
  # behavior around processing an action.
  _processAction: ->
    @["#{@actionName}Action"] @next
    @

  # Use it to define error handler for controller. Wrap any callback to handle
  # only successful results.
  #
  #   db.get id, @handleErrors (err, data) ->
  #     # here _err_ is always null
  #
  handleErrors: (fn) ->
    controller = @
    (err) ->
      return controller.next err if err
      fn.apply @, arguments
