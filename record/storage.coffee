_         = require 'underscore'
flow      = require 'flow-coffee'

# debug     = require('debug') 'record:storage'

module.exports =
class Storage extends require('coffee_classkit').Module
  @extendsWithProto().concern()

  class @ClassMethods
    find: (id, callback) ->
      @get id, (err, item) ->
        unless item || err?
          err = new Error 'Not found'
          err.status = 404
        callback? err, item

    update: (id, data, callback) ->
      @find id, (err, item) =>
        return callback? err if err
        item.update data, (err) -> callback? err, item

    create: (data, callback) ->
      item = new @(data)
      item.save (err) =>
        callback?.call @, err, item

    attr: (id, attr, callback) ->
      @get id, (err, item) ->
        return callback? err if err
        _.extend item, attr
        @set id, item, callback
      @

  # instance methods
  save: ->
    # debug "save #{@constructor.name}: is_persisted: #{@_isPersisted}"
    if @_isPersisted
      @_updateRecord arguments...
    else
      @_createRecord arguments...

  _updateRecord: (callback) ->
    # debug "_updateRecord: #{@id}"
    @constructor.set @id, @exportFor('db'), callback
    @

  _createRecord: (callback) ->
    done = (err) ->
      @_isPersisted = true unless err
      callback?.apply @, arguments
    if @id
      @constructor.set @id, @exportFor('db'), done
      return @
    # debug "before next @ #{@constructor.name}"
    @constructor.nextId (err, id) =>
      # debug "next #{@constructor.name}: #{id}"
      return done err if err
      @id = id
      @constructor.set id, @exportFor('db'), done
    @

  attr: (attr) ->
    # debug "attr #{@constructor.name}"
    _.extend @, attr
    # debug "attr #{@constructor.name}"
    @

  update: (attr, callback) ->
    # debug "update #{@constructor.name}"
    @attr(attr).save callback

  destroy: (callback) ->
    @constructor.delete @id, (err) ->
      unless err
        @_isPersisted = false
        @_isDestroyed = true
      callback arguments...
    @

  reload: (callback) ->
    @constructor.get @id, callback
    @

  transaction: (callback) ->
    @constructor.transaction callback
    @
