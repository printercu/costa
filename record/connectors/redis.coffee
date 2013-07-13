# debug = require('debug') 'record:connector:redis'

module.exports =
class Redis extends require('coffee_classkit').Module
  @extendsWithProto().concern()

  @include require './key_val'

  class @ClassMethods
    nextId: (callback) ->
      @kv.incr @_keySeq('id'), callback
      @

    get: (id, callback) ->
      key = @_key id
      # debug "GET: #{key}"
      @kv.get key, (err, data) =>
        # debug "GOT: #{key}"
        return callback? err if err
        try
          item = JSON.parse(data)
          item = null unless typeof item is 'object'
        catch err
          return callback? err
        if item
          item.__proto__    = @prototype
          item._isPersisted = true
        callback? null, item
      @

    set: (id, data, callback) ->
      key   = @_key(id)
      data  = JSON.stringify(data)
      # debug "SET #{key} #{data}"
      @kv.set key, data, callback
      @

    getMulti: (ids, callback) ->
      return callback? null, {} unless ids.length
      do new flow
        context:  @
        error:    callback
        blocks: [
          (flow) ->
            for id in ids
              do (cb = flow.multi()) => @get id, cb
          (err, results) ->
            items = {}
            # TODO: sort?
            for [err, item] in results
              items[item.id] = item
            callback? null, items
        ]
      @

    getMulti: (ids, callback) ->
      return setImmediate(-> callback null, []) unless ids.length
      keys = (@_key id for id in ids)
      @kv.mget keys, (err, items) =>
        return callback? err if err
        result = []
        for item_json in items
          try
            item = JSON.parse item_json
            item = null unless typeof item is 'object'
          catch err
            return callback? err
          item.__proto__ = @prototype if item
          result.push item
        callback? null, result
      @

    delete: (id, callback) ->
      @kv.del @_key(id), callback
      @
