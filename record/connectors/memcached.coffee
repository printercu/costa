# debug = require('debug') 'record:connector:memcached'

module.exports =
class Memcached extends require('coffee_classkit').Module
  @extendsWithProto().concern()

  @include require './redis'

  class @ClassMethods
    nextId: (callback) ->
      key = @_keySeq 'id'
      @kv.incr key, 1, (err, value) =>
        return callback? err, value if err? || value
        @kv.set key, 1, 0, (err) ->
          return callback? err if err
          callback? null, 1
      @

    set: (id, data, callback) ->
      key   = @_key(id)
      data  = JSON.stringify(data)
      # debug "SET #{key} #{data}"
      @kv.set key, data, 0, callback
      @

    getMulti: (ids, callback) ->
      return setImmediate(-> callback null, []) unless ids.length
      keys = (@_key id for id in ids)
      @kv.mget keys, (err, items) =>
        return callback? err if err
        result = []
        for key in keys
          item_json = items[key]
          if item_json
            try
              item = JSON.parse item_json
              item = null unless typeof item is 'object'
            catch err
              return callback? err
            item.__proto__ = @prototype if item
          else
            item = null
          result.push item
        callback? null, result
      @
