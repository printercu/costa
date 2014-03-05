assert    = require 'assert'

RequestController  = require '../../action_controller/request_controller'

describe 'RequestController', ->
  describe '.dispatch', ->
    beforeEach ->
      class @TestController extends RequestController
        @extendsWithProto()

        constructor: ->
          super
          @runs = []

        indexAction: (callback) ->
          @runs.push 'index'
          setImmediate -> callback?()

    it 'sets req, res, action & next properties', (done) ->
      @TestController::indexAction = (callback) ->
        assert.equal @actionName, 'index'
        assert.equal @request,    'req'
        assert.equal @response,   'res'
        @runs.push 'index'
        setImmediate callback
      controller = @TestController.dispatch 'index', 'req', 'res', next = ->
        done assert.deepEqual controller.runs, ['index']

    it 'returns created controller instance', ->
      assert @TestController.dispatch('index')?.constructor is @TestController

    it 'runs action method', (done) ->
      controller = @TestController.dispatch 'index', {}, {}, (err) ->
        assert.equal err, null
        assert.deepEqual controller.runs, ['index']
        done()

    context 'if controller does not have requested action', ->
      it 'passes error to callback', (done) ->
        @TestController.dispatch 'missing', {}, {}, (err) ->
          assert err
          done()

      it 'returns `false`', ->
        assert.equal @TestController.dispatch('missing'), false
